import 'package:flutter/material.dart';
import '../themes/my_theme.dart';

// widgets AppBar
class AppBarPrincipal extends StatelessWidget implements PreferredSizeWidget {
   const AppBarPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MisColores.color_secundario, // usa color secundario
      elevation: 4,
      title: Row(
        children: [
          Image.asset('assets/images/logo_emily.png', height: 36),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tienda Emily",
                style: MisFuentes.subtitulo.copyWith(color: Colors.white),
              ),

            ],
          ),
        ],
      ),

      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
          color: Colors.white,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
    //preferredSize
  //
  // Es una propiedad que informa al Scaffold cuál debe ser el tamaño preferido del AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 6);
}
