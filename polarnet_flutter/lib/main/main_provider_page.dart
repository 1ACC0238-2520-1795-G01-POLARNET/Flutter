import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:polarnet_flutter/features/auth/presentation/blocs/auth_state.dart';
import 'package:polarnet_flutter/features/provider/home/presentation/pages/provider_requests_page.dart';
import 'package:polarnet_flutter/features/provider/add/presentation/pages/add_equipment_page.dart';

class MainProviderPage extends StatefulWidget {
  const MainProviderPage({super.key});

  @override
  State<MainProviderPage> createState() => _MainProviderPageState();
}

class _MainProviderPageState extends State<MainProviderPage> {
  int _selectedIndex = 0;

  Widget _buildPage(int index, int providerId) {
    switch (index) {
      case 0:
        return const ProviderRequestsPage();
      case 1:
        return const Center(child: Text('Mis Equipos - Próximamente'));
      case 2:
        return AddEquipmentPage(
          providerId: providerId,
          onEquipmentAdded: () {},
        );
      case 3:
        return const Center(child: Text('Perfil - Próximamente'));
      default:
        return const ProviderRequestsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Obtener el providerId del usuario autenticado
        final providerId = authState is AuthAuthenticated
            ? (authState.user.id ?? 0)
            : 0;

        return Scaffold(
          body: SafeArea(child: _buildPage(_selectedIndex, providerId)),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (value) => setState(() => _selectedIndex = value),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(color: Colors.black),
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_outlined),
                activeIcon: Icon(Icons.inventory),
                label: 'Inventario',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                activeIcon: Icon(Icons.add_box),
                label: 'Agregar',
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
