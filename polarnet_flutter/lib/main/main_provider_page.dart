/*import 'package:flutter/material.dart';
import 'package:polar_net/features/provider/home/presentation/pages/home_provider_page.dart';
import 'package:polar_net/features/provider/equipment/presentation/pages/my_equipment_page.dart';
import 'package:polar_net/features/provider/profile/presentation/pages/profile_provider_page.dart';

class MainProviderPage extends StatefulWidget {
  const MainProviderPage({super.key});

  @override
  State<MainProviderPage> createState() => _MainProviderPageState();
}

class _MainProviderPageState extends State<MainProviderPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeProviderPage(),
    MyEquipmentPage(),
    ProfileProviderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            activeIcon: Icon(Icons.handyman),
            label: 'Equipos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}*/
