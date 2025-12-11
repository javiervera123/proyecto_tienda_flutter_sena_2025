import 'package:flutter/material.dart';

class FabCrearProducto extends StatelessWidget {
  const FabCrearProducto({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Ir al formulario de creación
      },
      child: const Icon(Icons.add),
    );
  }
}
