import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importa tus utilidades de estilo
import '../themes/my_theme.dart'; // Si tu plantilla de estilos está aquí
import '../widgets/appbar_principal.dart';
import '../widgets/buscador_widget.dart';
import '../widgets/categorias_snap_widget.dart';
import '../widgets/menu_inferior.dart';
// Importa los archivos necesarios
import 'catalogo_screen.dart';
import 'carrito_screen.dart';
import 'inicio_sesion_screen.dart';
import 'perfil_screen.dart';
import 'ajustes_screen.dart';
import '../models/producto.dart';
import '../providers/carrito_provider.dart';
import '../services/producto_service.dart'; // Necesario para obtener productos
import '../widgets/producto_card_widget.dart'; // Necesario para los destacados

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0; // Índice del BottomNavigationBar
  final ProductoService _productoService = ProductoService(); // Instancia del servicio

  // Lista de pantallas
  List<Widget> get paginas => [
    paginaInicio(),
    const CatalogoScreen(),
    CarritoScreen(),
    const PerfilScreen(),
    const AjustesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPrincipal(), // AppBar personalizado
      body: paginas[index], // Mostrar pantalla según índice
      bottomNavigationBar: MenuInferior(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value; // Cambiar pantalla al tocar nav
          });
        },
      ),
    );
  }

  /// ------------------------------
  /// 🏠 PANTALLA PRINCIPAL INICIO
  /// ------------------------------
  Widget paginaInicio() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BOTÓN INICIAR SESIÓN
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Usa tu estilo personalizado
                  MisBotones.botonSecundario(
                    texto: "Iniciar Sesión",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const InicioSesion()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // BUSCADOR -> ENVÍA AL CATALOGO
            Padding(
              padding: const EdgeInsets.all(16),
              child: BuscadorWidget(
                onChanged: (texto) {
                  // Navega al catálogo con el texto de búsqueda
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CatalogoScreen(
                        textoInicial: texto,
                      ),
                    ),
                  );
                },
                onSubmitted: (texto) {},
              ),
            ),

            const SizedBox(height: 10),

            // 🟡 CATEGORÍAS (horizontal)
            SizedBox(
              height: 180,
              child: CategoriasSnapWidget(),
            ),

            const SizedBox(height: 20),

            // 🌟 PRODUCTOS DESTACADOS (Título)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "🔥 Productos Destacados",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MisColores.texto),
              ),
            ),

            // 🚀 LISTA HORIZONTAL DE PRODUCTOS DESTACADOS
            SizedBox(
              height: 250, // Altura suficiente para la tarjeta
              child: FutureBuilder<List<Producto>>(
                // Usa el servicio para cargar los productos
                future: _productoService.obtenerProductos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No hay productos destacados."));
                  }

                  final productos = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      // Usa la tarjeta de producto creada previamente
                      return ProductoCardWidget(producto: productos[index]);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 40), // Espacio final para el scroll
          ],
        ),
      ),
    );
  }
}