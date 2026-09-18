import '../entities/ticket.dart';

abstract class QueueRepository {
  Future<Ticket> generateTicket(String userDni, String procedureType, String agency, String departamento, String provincia);
  Future<void> cancelTicket(String ticketId);
  Stream<Map<String, dynamic>> getQueueStatus();

  /// Stream de turnos en cola para el cajero (tiempo real).
  Stream<List<Ticket>> getQueueTickets();

  /// Atiende el siguiente turno (el más antiguo en_cola).
  Future<void> attendNextTicket();

  /// Restablece la cola global a cero.
  Future<void> resetQueue();

  /// Historial de turnos del usuario (atendidos y cancelados).
  Stream<List<Ticket>> getUserHistory(String userDni);

  /// Turno activo actual del usuario en tiempo real.
  Stream<Ticket?> getUserActiveTicket(String userDni);
}
