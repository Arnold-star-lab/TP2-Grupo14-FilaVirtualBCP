import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/queue_provider.dart';

class DashboardWidget extends ConsumerWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(queueStatusProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return statusAsync.when(
      data: (data) {
        final currentAttending = data['currentAttending'] ?? 0;
        final waitTime = data['estimatedWaitTimeMinutes'] ?? 0;
        final maxTicket = data['maxTicketGenerated'] ?? 0;
        final peopleInQueue = (maxTicket - currentAttending).clamp(0, 9999);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monitoreo en Tiempo Real',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.confirmation_number_rounded,
                    iconColor: AppColors.primaryOrange,
                    title: 'Atendiendo',
                    value: currentAttending.toString(),
                    gradient: LinearGradient(
                      colors: isDark 
                          ? [const Color(0xFF1A1A3E), const Color(0xFF2A2A5E)]
                          : [const Color(0xFF002A8D), const Color(0xFF3366CC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.timer_rounded,
                    iconColor: AppColors.primaryOrange,
                    title: 'Espera',
                    value: '$waitTime min',
                    gradient: LinearGradient(
                      colors: isDark 
                          ? [const Color(0xFF1A1A3E), const Color(0xFF2A2A5E)]
                          : [const Color(0xFF002A8D), const Color(0xFF3366CC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.people_rounded,
                    iconColor: AppColors.primaryOrange,
                    title: 'En cola',
                    value: peopleInQueue.toString(),
                    gradient: LinearGradient(
                      colors: isDark 
                          ? [const Color(0xFF1A1A3E), const Color(0xFF2A2A5E)]
                          : [const Color(0xFF002A8D), const Color(0xFF3366CC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(color: isDark ? AppColors.primaryOrange : AppColors.primaryBlue),
        ),
      ),
      error: (err, stack) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Error al cargar el dashboard',
            style: TextStyle(color: AppColors.dangerRed),
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final LinearGradient gradient;

  const _DashboardCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
