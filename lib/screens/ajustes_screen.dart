import 'package:flutter/material.dart';
import '../widgets/appbar_principal.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Pantalla de ajustes en construcción...",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
