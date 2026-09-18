class Ticket {
  final String id;
  final String userDni;
  final String procedureType;
  final String agency;
  final String departamento;
  final String provincia;
  final int ticketNumber;
  final DateTime createdAt;
  final String status; // 'en_cola', 'atendido', 'cancelado'

  Ticket({
    required this.id,
    required this.userDni,
    required this.procedureType,
    required this.agency,
    required this.departamento,
    required this.provincia,
    required this.ticketNumber,
    required this.createdAt,
    required this.status,
  });

  /// Crea un Ticket desde un documento de Firestore.
  factory Ticket.fromFirestore(String docId, Map<String, dynamic> data) {
    return Ticket(
      id: docId,
      userDni: data['userDni'] ?? '',
      procedureType: data['procedureType'] ?? '',
      agency: data['agency'] ?? '',
      departamento: data['departamento'] ?? '',
      provincia: data['provincia'] ?? '',
      ticketNumber: data['ticketNumber'] ?? 0,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      status: data['status'] ?? 'en_cola',
    );
  }

  /// Convierte el Ticket a un mapa para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'userDni': userDni,
      'procedureType': procedureType,
      'agency': agency,
      'departamento': departamento,
      'provincia': provincia,
      'ticketNumber': ticketNumber,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
