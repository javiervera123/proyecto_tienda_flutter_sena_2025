import 'package:flutter/material.dart';

import '../widgets/appbar_principal.dart';

class FavoritosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPrincipal(),
      body: const Center(child: Text("Pantalla de favoritos")),
    );
  }
}

