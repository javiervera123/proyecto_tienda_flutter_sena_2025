import 'package:flutter/material.dart';
import '../themes/my_theme.dart';

class MenuInferior extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MenuInferior({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: MisColores.color_secundario,

      currentIndex: currentIndex,
      onTap: onTap,

      type: BottomNavigationBarType.fixed,

      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),   // ← nuevo icono
          label: 'Productos',               // ← nuevo texto
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Carrito',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
    );
  }
}
