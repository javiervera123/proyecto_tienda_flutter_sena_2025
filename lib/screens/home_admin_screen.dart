import 'package:flutter/material.dart';
import 'package:ultimo_proyecto/widgets/appbar_principal.dart';
import '../themes/my_theme.dart'; // importa tu archivo con MisColores, MisFuentes, MisBotones, MisCards

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizado, ya maneja SafeArea automáticamente
      appBar: AppBarPrincipal(),

      // Drawer lateral con menú tipo hamburguesa
      drawer: _buildDrawer(context),

      // SafeArea protege contenido para que no quede oculto por barras del sistema
      body: SafeArea(
        child: Column(
          children: [
            // Texto principal en el body
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Panel Administrador",
                style: MisFuentes.titulo,
              ),
            ),
            const SizedBox(height: 10),

            // Grid de opciones administrativas usando tus cards personalizadas
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // 3 cards por fila
                padding: const EdgeInsets.all(15),
                childAspectRatio: 0.7,
                children: [
                  _card(context, Icons.shopping_bag, "Productos"),
                  _card(context, Icons.category, "Categorías"),
                  _card(context, Icons.inventory, "Inventario"),
                  _card(context, Icons.people, "Clientes"),
                  _card(context, Icons.group, "Empleados"),
                  _card(context, Icons.store, "Proveedores"),
                  _card(context, Icons.local_offer, "Ofertas"),
                  _card(context, Icons.receipt_long, "Pedidos"),
                  _card(context, Icons.attach_money, "Ventas"),
                  _card(context, Icons.fact_check, "Facturas"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ------------------------------
  /// Crea cada card usando tu tema personalizado
  /// ------------------------------
  Widget _card(BuildContext context, IconData icon, String title) {
    return MisCards.cardBasico(
      child: InkWell(
        onTap: () {
          // Aquí puedes agregar navegación a la pantalla correspondiente
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: MisColores.color_secundario),
            const SizedBox(height: 10),
            Text(title, style: MisFuentes.subtitulo, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  /// ------------------------------
  /// Crea el Drawer lateral
  /// ------------------------------
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Administrador",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _item(Icons.home, "Inicio", context),
          _item(Icons.shopping_bag, "Productos", context),
          _item(Icons.category, "Categorías", context),
          _item(Icons.verified, "Ventas", context),
          _item(Icons.logout, "Cerrar sesión", context), // botón de cerrar sesión
        ],
      ),
    );
  }

  /// ------------------------------
  /// Crea cada item del Drawer
  /// ------------------------------
  ListTile _item(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: MisColores.color_secundario),
      title: Text(title, style: MisFuentes.subtitulo),
      onTap: () {
        if (title.toLowerCase() == "cerrar sesión") {
          Navigator.pop(context); // Cierra el Drawer primero
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home_screen', // Pantalla principal
                (route) => false, // Elimina todo el historial
          );
        } else {
          // Aquí puedes manejar navegación a otras pantallas
        }
      },
    );
  }
}
