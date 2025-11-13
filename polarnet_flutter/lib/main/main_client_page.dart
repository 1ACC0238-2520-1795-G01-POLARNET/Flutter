import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_state.dart';
import 'package:polarnet_flutter/features/client/home/presentation/pages/client_home_page.dart';
import 'package:polarnet_flutter/features/client/home/presentation/pages/equipment_detail.dart';
import 'package:polarnet_flutter/features/client/equipments/presentation/pages/client_equipments_page.dart';
import 'package:polarnet_flutter/features/client/services/presentation/pages/services_page.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class MainClientPage extends StatefulWidget {
  const MainClientPage({super.key});

  @override
  State<MainClientPage> createState() => _MainClientPageState();
}

class _MainClientPageState extends State<MainClientPage> {
  int _selectedIndex = 0;

  void _navigateToEquipmentDetail(Equipment equipment, int clientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipmentDetailPage(
          equipment: equipment,
          clientId: clientId,
        ),
      ),
    );
  }

  Widget _buildPage(int index, int clientId) {
    switch (index) {
      case 0:
        return const ClientHomePage();
      case 1:
        return ClientEquipmentsPage(
          clientId: clientId,
          onTapEquipmentCard: _navigateToEquipmentDetail,
        );
      case 2:
        return ServicesPage(clientId: clientId);
      case 3:
        return const Center(child: Text('Perfil - En construcción'));
      default:
        return const ClientHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Obtener el clientId del usuario autenticado
        final clientId = authState is AuthAuthenticated
            ? (authState.user.id ?? 0)
            : 0;

        return Scaffold(
          body: SafeArea(
            child: _buildPage(_selectedIndex, clientId),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (value) => setState(() => _selectedIndex = value),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(
              color: Colors.black,
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.black,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.build_outlined),
                activeIcon: Icon(Icons.build),
                label: 'Mis Equipos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt),
                label: 'Servicios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}
