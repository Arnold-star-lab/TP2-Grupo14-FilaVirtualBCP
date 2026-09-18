import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RequisitosScreen extends StatelessWidget {
  const RequisitosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;

    final requisitos = [
      {
        'titulo': 'Operaciones en Ventanilla',
        'icon': Icons.account_balance_wallet_rounded,
        'items': [
          'DNI original vigente',
          'Número de cuenta (si aplica)',
          'Monto exacto en efectivo para depósitos',
          'Voucher o constancia de operación previa',
        ],
      },
      {
        'titulo': 'Apertura de Cuentas',
        'icon': Icons.add_card_rounded,
        'items': [
          'DNI original vigente',
          'Recibo de servicios (luz, agua o teléfono)',
          'Comprobante de ingresos o boleta de pago',
          'Depósito mínimo de apertura (S/ 50.00)',
        ],
      },
      {
        'titulo': 'Préstamos y Tarjetas',
        'icon': Icons.credit_card_rounded,
        'items': [
          'DNI original vigente',
          'Últimas 3 boletas de pago',
          'Recibo de servicios a nombre del solicitante',
          'Declaración jurada de domicilio (si aplica)',
          'Historial crediticio favorable',
        ],
      },
      {
        'titulo': 'Reclamos y Consultas',
        'icon': Icons.support_agent_rounded,
        'items': [
          'DNI original vigente',
          'Número de operación o transacción',
          'Comprobante o voucher de la operación',
          'Descripción detallada del reclamo',
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Requisitos de Trámites'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: requisitos.length,
        itemBuilder: (context, index) {
          final req = requisitos[index];
          final items = req['items'] as List<String>;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : AppColors.cardShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con gradiente
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF002A8D), Color(0xFF3366CC)],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(req['icon'] as IconData, color: AppColors.primaryOrange, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          req['titulo'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Lista de requisitos
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, 
                              color: AppColors.primaryOrange, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
