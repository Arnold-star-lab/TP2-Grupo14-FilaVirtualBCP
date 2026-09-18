import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/queue_repository.dart';
import '../../data/repositories/queue_repository_impl.dart';
import '../../domain/entities/ticket.dart';

final queueRepositoryProvider = Provider<QueueRepository>((ref) {
  return QueueRepositoryImpl();
});

final queueStatusProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return repository.getQueueStatus();
});

/// Stream de turnos en cola para el panel del Cajero (tiempo real).
final queueTicketsProvider = StreamProvider<List<Ticket>>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return repository.getQueueTickets();
});

/// Stream de historial de turnos de un usuario específico.
/// Se usa con .family para pasar el DNI del usuario.
final userHistoryProvider = StreamProvider.family<List<Ticket>, String>((ref, userDni) {
  final repository = ref.watch(queueRepositoryProvider);
  return repository.getUserHistory(userDni);
});

/// Stream del turno activo actual del usuario en tiempo real.
final userActiveTicketProvider = StreamProvider.family<Ticket?, String>((ref, userDni) {
  final repository = ref.watch(queueRepositoryProvider);
  return repository.getUserActiveTicket(userDni);
});

class QueueController extends AsyncNotifier<Ticket?> {
  late QueueRepository _repository;

  @override
  FutureOr<Ticket?> build() {
    _repository = ref.watch(queueRepositoryProvider);
    return null; // Initial state: no ticket
  }

  Future<void> generateTicket(String userDni, String procedureType, String agency, String departamento, String provincia) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.generateTicket(userDni, procedureType, agency, departamento, provincia));
  }

  Future<void> cancelTicket(String ticketId) async {
    state = const AsyncLoading();
    try {
      await _repository.cancelTicket(ticketId);
      state = const AsyncData(null); // Clear the ticket locally just in case
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> attendNextTicket() async {
    try {
      await _repository.attendNextTicket();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> resetQueue() async {
    try {
      await _repository.resetQueue();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final queueControllerProvider = AsyncNotifierProvider<QueueController, Ticket?>(() {
  return QueueController();
});
