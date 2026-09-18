import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/queue_provider.dart';

class HistorialScreen extends ConsumerWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.primaryBlue;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.subtitleGrey;

    // Obtener el DNI del usuario autenticado
    final authState = ref.watch(authStateProvider);
    final userDni = authState.whenOrNull(data: (dni) => dni) ?? '';

    // Stream del historial de turnos del usuario
    final historialAsync = ref.watch(userHistoryProvider(userDni));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Turnos'),
      ),
      body: historialAsync.when(
        data: (tickets) {
          if (tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 80, color: subtitleColor.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'Sin historial',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aún no tienes turnos atendidos o cancelados.',
                    style: TextStyle(fontSize: 14, color: subtitleColor),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              final esAtendido = ticket.status == 'atendido';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : AppColors.cardShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    // Número de turno con color según estado
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: esAtendido
                              ? [AppColors.successGreen, const Color(0xFF27AE60)]
                              : [AppColors.dangerRed, const Color(0xFFC0392B)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          '${ticket.ticketNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Detalle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket.procedureType,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${ticket.agency}',
                            style: TextStyle(fontSize: 12, color: subtitleColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '📅 ${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year} - ${ticket.createdAt.hour.toString().padLeft(2, '0')}:${ticket.createdAt.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 12, color: subtitleColor),
                          ),
                        ],
                      ),
                    ),
                    // Badge de estado
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: (esAtendido ? AppColors.successGreen : AppColors.dangerRed).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            esAtendido ? Icons.check_circle : Icons.cancel,
                            color: esAtendido ? AppColors.successGreen : AppColors.dangerRed,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            esAtendido ? 'Atendido' : 'Cancelado',
                            style: TextStyle(
                              color: esAtendido ? AppColors.successGreen : AppColors.dangerRed,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 60, color: AppColors.dangerRed),
              const SizedBox(height: 12),
              Text('Error al cargar el historial', style: TextStyle(color: textColor)),
              const SizedBox(height: 4),
              Text(err.toString(), style: TextStyle(color: subtitleColor, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
