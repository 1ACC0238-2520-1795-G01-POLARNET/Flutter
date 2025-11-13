import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/core/theme/app_colors.dart';
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_event.dart';
import 'package:polarnet_flutter/shared/profile/presentation/blocs/profile_bloc.dart';
import 'package:polarnet_flutter/shared/profile/presentation/blocs/profile_event.dart';
import 'package:polarnet_flutter/shared/profile/presentation/blocs/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(const LoadProfile());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfileStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.error ?? 'Error al cargar perfil'),
                ],
              ),
            );
          }

          final user = state.user;

          return Column(
            children: [
              // Header con gradiente
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                      AppColors.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 48,
                  bottom: 48,
                ),
                child: Column(
                  children: [
                    // Avatar circular
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nombre
                    Text(
                      user?.fullName ?? 'Usuario desconocido',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rol con badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getRoleIcon(user?.role.name),
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getRoleText(user?.role.name),
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido scrolleable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección: Información Personal
                      _SectionHeader(
                        icon: Icons.info,
                        title: 'Información Personal',
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: 16),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: colorScheme.surfaceContainerLow,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _ProfileInfoItem(
                                icon: Icons.email,
                                label: 'Correo electrónico',
                                value: user?.email ?? 'No disponible',
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                              ),
                              if (user?.phone != null &&
                                  user!.phone!.isNotEmpty) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    color: colorScheme.outlineVariant
                                        // ignore: deprecated_member_use
                                        .withOpacity(0.5),
                                  ),
                                ),
                                _ProfileInfoItem(
                                  icon: Icons.phone,
                                  label: 'Teléfono',
                                  value: user.phone!,
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                ),
                              ],
                              if (user?.location != null &&
                                  user!.location!.isNotEmpty) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    color: colorScheme.outlineVariant
                                        // ignore: deprecated_member_use
                                        .withOpacity(0.5),
                                  ),
                                ),
                                _ProfileInfoItem(
                                  icon: Icons.location_on,
                                  label: 'Ubicación',
                                  value: user.location!,
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                ),
                              ],
                              if (user?.companyName != null &&
                                  user!.companyName!.isNotEmpty) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    color: colorScheme.outlineVariant
                                        // ignore: deprecated_member_use
                                        .withOpacity(0.5),
                                  ),
                                ),
                                _ProfileInfoItem(
                                  icon: Icons.business,
                                  label: 'Empresa',
                                  value: user.companyName!,
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Sección: Cuenta
                      _SectionHeader(
                        icon: Icons.settings,
                        title: 'Configuración de Cuenta',
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: 16),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: colorScheme.surfaceContainerLow,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _ProfileInfoItem(
                                icon: Icons.badge,
                                label: 'ID de Usuario',
                                value: user?.id?.toString() ?? 'N/A',
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Divider(
                                  color: colorScheme.outlineVariant
                                      // ignore: deprecated_member_use
                                      .withOpacity(0.5),
                                ),
                              ),
                              _ProfileInfoItem(
                                icon: Icons.verified_user,
                                label: 'Estado de cuenta',
                                value: 'Activa',
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botón de cerrar sesión
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            _showLogoutDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                'Cerrar Sesión',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getRoleIcon(String? role) {
    switch (role?.toUpperCase()) {
      case 'CLIENT':
        return Icons.person_outline;
      case 'PROVIDER':
        return Icons.business;
      default:
        return Icons.help;
    }
  }

  String _getRoleText(String? role) {
    switch (role?.toUpperCase()) {
      case 'CLIENT':
        return 'Cliente';
      case 'PROVIDER':
        return 'Proveedor';
      default:
        return 'Rol desconocido';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ProfileInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
