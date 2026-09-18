import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/data/location_data.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/queue_provider.dart';
import '../widgets/dashboard_widget.dart';
import 'historial_screen.dart';
import 'requisitos_screen.dart';

class MainQueuePage extends ConsumerStatefulWidget {
  const MainQueuePage({super.key});

  @override
  ConsumerState<MainQueuePage> createState() => _MainQueuePageState();
}

class _MainQueuePageState extends ConsumerState<MainQueuePage> {
  final List<String> _procedureTypes = [
    'Operaciones en Ventanilla',
    'Apertura de Cuentas',
    'Préstamos y Tarjetas',
    'Reclamos y Consultas',
  ];

  String? _selectedProcedure;
  String? _selectedAgency;
  String? _selectedDepartamento;
  String? _selectedProvincia;

  void _resetCascadeFromDepartamento() {
    _selectedProvincia = null;
    _selectedAgency = null;
  }

  void _resetCascadeFromProvincia() {
    _selectedAgency = null;
  }

  @override
  Widget build(BuildContext context) {
    final queueState = ref.watch(queueControllerProvider);
    final authState = ref.watch(authStateProvider);
    final queueStatus = ref.watch(queueStatusProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Extraer el DNI del usuario para el saludo
    final userDni = authState.whenOrNull(data: (dni) => dni) ?? 'Usuario';
    final activeTicketAsync = ref.watch(userActiveTicketProvider(userDni));
    final activeTicket = activeTicketAsync.value;

    // Colores adaptativos según el tema
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primaryBlue;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.subtitleGrey;
    final fillColor = isDark ? AppColors.darkSurface : AppColors.background;

    // Listas dependientes
    final provinciasDisponibles = _selectedDepartamento != null
        ? LocationData.getProvincias(_selectedDepartamento!)
        : <String>[];

    final agenciasDisponibles = _selectedProvincia != null
        ? LocationData.getAgencias(_selectedProvincia!)
        : <String>[];

    ref.listen(queueControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceAll('Exception: ', '')),
              backgroundColor: AppColors.dangerRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        data: (ticket) {
          if (ticket != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ Turno ${ticket.ticketNumber} generado con éxito.',
                ),
                backgroundColor: AppColors.successGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'imagenes/icono_bcp.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 28,
                );
              },
            ),
            const SizedBox(width: 10),
            const Text(
              'Fila Virtual BCP',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      // === DRAWER (Menú lateral) ===
      drawer: _buildDrawer(
        context,
        userDni,
        isDark,
        cardColor,
        textColor,
        subtitleColor,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === GREETING CARD ===
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7A00), Color(0xFFFF9A40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, $userDni 👋',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bienvenido a tu fila virtual',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // === DASHBOARD ===
              const DashboardWidget(),
              const SizedBox(height: 28),

              // === SOLICITAR TURNO ===
              if (activeTicket == null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(
                                alpha: isDark ? 0.2 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.add_circle_rounded,
                              color: isDark
                                  ? AppColors.lightBlue
                                  : AppColors.primaryBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Solicitar Nuevo Turno',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // === 1. DROPDOWN DEPARTAMENTO ===
                      DropdownButtonFormField<String>(
                        key: ValueKey('dep_$_selectedDepartamento'),
                        decoration: InputDecoration(
                          labelText: 'Departamento',
                          prefixIcon: Icon(
                            Icons.map_rounded,
                            color: isDark
                                ? AppColors.primaryOrange
                                : AppColors.primaryBlue,
                          ),
                          filled: true,
                          fillColor: fillColor,
                        ),
                        initialValue: _selectedDepartamento,
                        dropdownColor: cardColor,
                        items: LocationData.departamentos.map((dep) {
                          return DropdownMenuItem(value: dep, child: Text(dep));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartamento = value;
                            _resetCascadeFromDepartamento();
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // === 2. DROPDOWN PROVINCIA (depende de Departamento) ===
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          'prov_${_selectedDepartamento}_$_selectedProvincia',
                        ),
                        decoration: InputDecoration(
                          labelText: _selectedDepartamento == null
                              ? 'Provincia (selecciona departamento)'
                              : 'Provincia',
                          prefixIcon: Icon(
                            Icons.location_city_rounded,
                            color: isDark
                                ? AppColors.primaryOrange
                                : AppColors.primaryBlue,
                          ),
                          filled: true,
                          fillColor: fillColor,
                        ),
                        initialValue: _selectedProvincia,
                        dropdownColor: cardColor,
                        items: provinciasDisponibles.map((prov) {
                          return DropdownMenuItem(
                            value: prov,
                            child: Text(prov),
                          );
                        }).toList(),
                        onChanged: _selectedDepartamento == null
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedProvincia = value;
                                  _resetCascadeFromProvincia();
                                });
                              },
                      ),
                      const SizedBox(height: 16),

                      // === 3. DROPDOWN AGENCIA (depende de Provincia) ===
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          'agency_${_selectedProvincia}_$_selectedAgency',
                        ),
                        decoration: InputDecoration(
                          labelText: _selectedProvincia == null
                              ? 'Agencia (selecciona provincia)'
                              : 'Agencia BCP',
                          prefixIcon: Icon(
                            Icons.store_rounded,
                            color: isDark
                                ? AppColors.primaryOrange
                                : AppColors.primaryBlue,
                          ),
                          filled: true,
                          fillColor: fillColor,
                        ),
                        initialValue: _selectedAgency,
                        dropdownColor: cardColor,
                        items: agenciasDisponibles.map((agency) {
                          return DropdownMenuItem(
                            value: agency,
                            child: Text(
                              agency,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _selectedProvincia == null
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedAgency = value;
                                });
                              },
                      ),
                      const SizedBox(height: 16),

                      // === 4. DROPDOWN TRÁMITE ===
                      DropdownButtonFormField<String>(
                        key: ValueKey('procedure_$_selectedProcedure'),
                        decoration: InputDecoration(
                          labelText: 'Tipo de Trámite',
                          prefixIcon: Icon(
                            Icons.list_alt_rounded,
                            color: isDark
                                ? AppColors.primaryOrange
                                : AppColors.primaryBlue,
                          ),
                          filled: true,
                          fillColor: fillColor,
                        ),
                        initialValue: _selectedProcedure,
                        dropdownColor: cardColor,
                        items: _procedureTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProcedure = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Botón Generar Turno
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.confirmation_number_rounded),
                          onPressed:
                              (_selectedProcedure == null ||
                                  _selectedAgency == null ||
                                  _selectedDepartamento == null ||
                                  _selectedProvincia == null ||
                                  queueState.isLoading)
                              ? null
                              : () {
                                  ref
                                      .read(queueControllerProvider.notifier)
                                      .generateTicket(
                                        userDni,
                                        _selectedProcedure!,
                                        _selectedAgency!,
                                        _selectedDepartamento!,
                                        _selectedProvincia!,
                                      );
                                },
                          label: queueState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Generar Turno'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // === TICKET CARD ===
              if (activeTicket != null) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black38
                            : AppColors.primaryBlue.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.primaryBlue.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.successGreen,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Turno Generado',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ticket Number
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF002A8D), Color(0xFF3366CC)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${activeTicket.ticketNumber}',
                          style: const TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Procedure type
                      Text(
                        activeTicket.procedureType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Agency
                      Text(
                        '📍 ${activeTicket.agency}',
                        style: TextStyle(fontSize: 13, color: subtitleColor),
                      ),
                      const SizedBox(height: 2),

                      // Departamento y Provincia
                      Text(
                        '🗺️ ${activeTicket.provincia}, ${activeTicket.departamento}',
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                      ),
                      const SizedBox(height: 16),

                      // Queue position calculation
                      queueStatus.when(
                        data: (data) {
                          final currentAttending =
                              data['currentAttending'] ?? 0;
                          final userTicket = activeTicket.ticketNumber;
                          final peopleAhead = (userTicket - currentAttending)
                              .clamp(0, 9999);

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.primaryBlue.withValues(
                                      alpha: 0.15,
                                    )
                                  : AppColors.primaryBlue.withValues(
                                      alpha: 0.06,
                                    ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.group_rounded,
                                      color: isDark
                                          ? AppColors.lightBlue
                                          : AppColors.primaryBlue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        peopleAhead == 0
                                            ? '¡Es tu turno! 🎉'
                                            : 'Faltan $peopleAhead persona${peopleAhead == 1 ? '' : 's'} antes de ti',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: peopleAhead == 0
                                              ? AppColors.successGreen
                                              : textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (peopleAhead > 0) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tiempo estimado: ~${peopleAhead * 5} min',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Por favor, acércate a la ventanilla cuando sea tu turno.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                      ),
                      const SizedBox(height: 20),

                      // Cancelar turno
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.cancel_rounded),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.dangerRed,
                            side: const BorderSide(
                              color: AppColors.dangerRed,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: queueState.isLoading
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: cardColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: Text(
                                        'Cancelar turno',
                                        style: TextStyle(color: textColor),
                                      ),
                                      content: Text(
                                        '¿Estás seguro de que deseas cancelar tu turno? Esta acción no se puede deshacer.',
                                        style: TextStyle(color: subtitleColor),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              color: subtitleColor,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            ref
                                                .read(
                                                  queueControllerProvider
                                                      .notifier,
                                                )
                                                .cancelTicket(activeTicket.id);
                                            setState(() {
                                              _selectedProcedure = null;
                                              _selectedAgency = null;
                                              _selectedDepartamento = null;
                                              _selectedProvincia = null;
                                            });
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Tu turno ha sido cancelado.',
                                                ),
                                                backgroundColor:
                                                    AppColors.dangerRed,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Sí, cancelar',
                                            style: TextStyle(
                                              color: AppColors.dangerRed,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          label: const Text(
                            'Cancelar mi turno',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // === DRAWER WIDGET ===
  Widget _buildDrawer(
    BuildContext context,
    String userDni,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    final themeNotifier = ref.watch(themeModeProvider.notifier);

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      child: Column(
        children: [
          // === DRAWER HEADER ===
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF002A8D), Color(0xFF001A5C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Usuario: $userDni',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fila Virtual BCP',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // === OPCIONES DEL MENÚ ===
          ListTile(
            leading: Icon(
              Icons.home_rounded,
              color: isDark ? AppColors.primaryOrange : AppColors.primaryBlue,
            ),
            title: Text(
              'Inicio',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history_rounded,
              color: isDark ? AppColors.primaryOrange : AppColors.primaryBlue,
            ),
            title: Text(
              'Historial de Turnos',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistorialScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.description_rounded,
              color: isDark ? AppColors.primaryOrange : AppColors.primaryBlue,
            ),
            title: Text(
              'Requisitos de Trámites',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequisitosScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // === MODO OSCURO ===
          ListTile(
            leading: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? AppColors.primaryOrange : AppColors.primaryBlue,
            ),
            title: Text(
              'Modo Oscuro',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
            trailing: Switch(
              value: isDark,
              activeThumbColor: AppColors.primaryOrange,
              onChanged: (_) {
                themeNotifier.toggleTheme();
              },
            ),
            onTap: () {
              themeNotifier.toggleTheme();
            },
          ),

          const Spacer(),

          // === CERRAR SESIÓN (al fondo) ===
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: AppColors.dangerRed,
            ),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: AppColors.dangerRed,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Cerrar drawer
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
