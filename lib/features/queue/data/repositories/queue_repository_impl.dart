import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/queue_repository.dart';

class QueueRepositoryImpl implements QueueRepository {
  final FirebaseFirestore _firestore;
  
  QueueRepositoryImpl({FirebaseFirestore? firestore}) 
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Emula la respuesta de la API interna del banco (Mock)
  Future<bool> _mockCheckAvailability(String procedureType) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula latencia de red
    
    // Simular que el 90% de las veces hay disponibilidad
    final isAvailable = Random().nextInt(100) < 90;
    if (!isAvailable) {
      throw Exception('El sistema interno indica que no hay turnos disponibles para $procedureType por el momento.');
    }
    return true;
  }

  @override
  Future<Ticket> generateTicket(String userDni, String procedureType, String agency, String departamento, String provincia) async {
    // 1. Validar con Mock API
    await _mockCheckAvailability(procedureType);

    // 2. Transacción Firestore para asegurar consistencia
    final statusRef = _firestore.collection('queue').doc('status');
    final userTicketRef = _firestore.collection('tickets').doc();

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(statusRef);
      
      int currentMaxTicket = 0;
      int currentWaitTime = 0;

      if (snapshot.exists) {
        currentMaxTicket = snapshot.data()?['maxTicketGenerated'] ?? 0;
        currentWaitTime = snapshot.data()?['estimatedWaitTimeMinutes'] ?? 0;
      }

      final newTicketNumber = currentMaxTicket + 1;
      
      // Simular que cada turno agrega 5 minutos a la espera global
      final newWaitTime = currentWaitTime + 5;

      final ticket = Ticket(
        id: userTicketRef.id,
        userDni: userDni,
        procedureType: procedureType,
        agency: agency,
        departamento: departamento,
        provincia: provincia,
        ticketNumber: newTicketNumber,
        createdAt: DateTime.now(),
        status: 'en_cola',
      );

      transaction.set(userTicketRef, ticket.toFirestore());

      transaction.set(statusRef, {
        'currentAttending': snapshot.exists ? (snapshot.data()?['currentAttending'] ?? 1) : 1,
        'maxTicketGenerated': newTicketNumber,
        'estimatedWaitTimeMinutes': newWaitTime,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return ticket;
    });
  }

  @override
  Future<void> cancelTicket(String ticketId) async {
    // Marcar el ticket como cancelado en Firestore
    await _firestore.collection('tickets').doc(ticketId).update({
      'status': 'cancelado',
    });

    // Reducir tiempo de espera estimado en el status global
    final statusRef = _firestore.collection('queue').doc('status');
    final snapshot = await statusRef.get();
    if (snapshot.exists) {
      final currentWaitTime = snapshot.data()?['estimatedWaitTimeMinutes'] ?? 0;
      final newWaitTime = (currentWaitTime - 5).clamp(0, 9999);
      await statusRef.update({
        'estimatedWaitTimeMinutes': newWaitTime,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Stream<Map<String, dynamic>> getQueueStatus() {
    return _firestore.collection('queue').doc('status').snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!;
      }
      return {
        'currentAttending': 0,
        'estimatedWaitTimeMinutes': 0,
      };
    });
  }

  /// Stream en tiempo real de todos los turnos con estado 'en_cola' o 'waiting',
  /// ordenados por número de turno ascendente (el más antiguo primero).
  @override
  Stream<List<Ticket>> getQueueTickets() {
    return _firestore
        .collection('tickets')
        .where('status', whereIn: ['en_cola', 'waiting'])
        .snapshots()
        .map((snapshot) {
      final tickets = snapshot.docs.map((doc) {
        return Ticket.fromFirestore(doc.id, doc.data());
      }).toList();
      // Ordenar en el cliente para evitar índice compuesto
      tickets.sort((a, b) => a.ticketNumber.compareTo(b.ticketNumber));
      return tickets;
    });
  }

  /// Atiende el siguiente turno: toma el primero en cola y lo marca como 'atendido'.
  /// También actualiza el campo 'currentAttending' en el status global.
  @override
  Future<void> attendNextTicket() async {
    // Buscar el turno más antiguo en cola
    final querySnapshot = await _firestore
        .collection('tickets')
        .where('status', whereIn: ['en_cola', 'waiting'])
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('No hay turnos en cola para atender.');
    }

    // Ordenar en cliente y tomar el primero
    final docs = querySnapshot.docs.toList();
    docs.sort((a, b) => (a.data()['ticketNumber'] as int).compareTo(b.data()['ticketNumber'] as int));
    final ticketDoc = docs.first;
    final ticketNumber = ticketDoc.data()['ticketNumber'] ?? 0;

    // Actualizar el turno a 'atendido'
    await _firestore.collection('tickets').doc(ticketDoc.id).update({
      'status': 'atendido',
    });

    // Actualizar el status global: currentAttending = número del turno atendido
    final statusRef = _firestore.collection('queue').doc('status');
    final statusSnapshot = await statusRef.get();
    if (statusSnapshot.exists) {
      final currentWaitTime = statusSnapshot.data()?['estimatedWaitTimeMinutes'] ?? 0;
      final newWaitTime = (currentWaitTime - 5).clamp(0, 9999);
      await statusRef.update({
        'currentAttending': ticketNumber,
        'estimatedWaitTimeMinutes': newWaitTime,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Restablece la cola global a cero. Elimina los turnos en cola actuales.
  @override
  Future<void> resetQueue() async {
    final statusRef = _firestore.collection('queue').doc('status');
    await statusRef.set({
      'maxTicketGenerated': 0,
      'currentAttending': 0,
      'estimatedWaitTimeMinutes': 0,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });

    // Opcional: Cancelar todos los turnos que sigan en cola para evitar conflictos
    final querySnapshot = await _firestore
        .collection('tickets')
        .where('status', whereIn: ['en_cola', 'waiting'])
        .get();

    final batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'status': 'cancelado'});
    }
    await batch.commit();
  }

  /// Historial de turnos de un usuario específico (atendidos y cancelados).
  /// Filtra por userDni y luego ordena/filtra en el cliente.
  @override
  Stream<List<Ticket>> getUserHistory(String userDni) {
    return _firestore
        .collection('tickets')
        .where('userDni', isEqualTo: userDni)
        .snapshots()
        .map((snapshot) {
      final tickets = snapshot.docs
          .map((doc) => Ticket.fromFirestore(doc.id, doc.data()))
          .where((t) => t.status == 'atendido' || t.status == 'cancelado')
          .toList();
      // Ordenar por ticketNumber descendente (más reciente primero)
      tickets.sort((a, b) => b.ticketNumber.compareTo(a.ticketNumber));
      return tickets;
    });
  }

  /// Turno activo actual del usuario en tiempo real (en_cola o waiting).
  @override
  Stream<Ticket?> getUserActiveTicket(String userDni) {
    return _firestore
        .collection('tickets')
        .where('userDni', isEqualTo: userDni)
        .snapshots()
        .map((snapshot) {
      final activeTickets = snapshot.docs
          .map((doc) => Ticket.fromFirestore(doc.id, doc.data()))
          .where((t) => t.status == 'en_cola' || t.status == 'waiting')
          .toList();
      
      if (activeTickets.isEmpty) return null;
      return activeTickets.first;
    });
  }
}
