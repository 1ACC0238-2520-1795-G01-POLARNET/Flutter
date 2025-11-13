import 'package:flutter/material.dart';
import 'package:polarnet_flutter/features/client/home/presentation/pages/client_home_page.dart';

class MainClientPage extends StatefulWidget {
  const MainClientPage({super.key});

  @override
  State<MainClientPage> createState() => _MainClientPageState();
}

class _MainClientPageState extends State<MainClientPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ClientHomePage(),
    Center(child: Text('Mis Equipos - En construcción')),
    Center(child: Text('Servicios - En construcción')),
    Center(child: Text('Perfil - En construcción')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
        selectedItemColor: Colors.black, // Color cuando está seleccionado
        unselectedItemColor: Colors.black, // Color cuando NO está seleccionado
        selectedLabelStyle: TextStyle(
          color: Colors.black,
        ), // Texto seleccionado
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ), // Texto no seleccionado
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
  }
}
