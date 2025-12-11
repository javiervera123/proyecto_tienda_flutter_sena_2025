import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import '../widgets/buscador_widget.dart';
import '../widgets/categorias_snap_widget.dart';
import 'detalle_producto_screen.dart';
import '../providers/carrito_provider.dart';

class CatalogoScreen extends StatefulWidget {
  final String? textoInicial; // Texto inicial para filtrar productos

  const CatalogoScreen({super.key, this.textoInicial});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final ProductoService _service = ProductoService();
  List<Producto> productos = [];
  List<Producto> productosFiltrados = [];
  bool cargando = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    cargarProductos().then((_) {
      if (widget.textoInicial != null && widget.textoInicial!.isNotEmpty) {
        filtrar(widget.textoInicial!);
      }
    });
  }

  Future<void> cargarProductos() async {
    try {
      final lista = await _service.obtenerProductos();
      setState(() {
        productos = lista;
        productosFiltrados = lista;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        error = "Error cargando productos";
        cargando = false;
      });
    }
  }

  void filtrar(String texto) {
    texto = texto.toLowerCase();
    setState(() {
      productosFiltrados = productos
          .where((p) => p.nombre.toLowerCase().contains(texto))
          .toList();
    });
  }

  Widget _catalogoUI() {
    return Column(
      children: [
        // Buscador
        Padding(
          padding: const EdgeInsets.all(12),
          child: BuscadorWidget(
            onChanged: filtrar,
            onSubmitted: (texto) {},
          ),
        ),

        // Barra horizontal de categorías (si la agregas)
        SizedBox(
          height: 180,
          child: CategoriasSnapWidget(),
        ),

        const SizedBox(height: 10),

        // Lista de productos
        Expanded(
          child: productosFiltrados.isEmpty
              ? const Center(child: Text("No hay productos"))
              : ListView.builder(
            itemCount: productosFiltrados.length,
            itemBuilder: (_, i) {
              final p = productosFiltrados[i];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                elevation: 3,
                child: ListTile(
                  leading: p.imagen.isNotEmpty
                      ? Image.network(
                    p.imagen,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image),
                  title: Text(p.nombre),
                  subtitle:
                  Text("\$${p.precio.toStringAsFixed(2)}"),

                  // Navegar al detalle
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalleProductoScreen(producto: p), // Solo el producto
                      ),
                    );

                  },

                  // Botón agregar al carrito usando Provider
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      final carrito = Provider.of<CarritoProvider>(
                          context,
                          listen: false);
                      carrito.agregarProducto(p);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${p.nombre} agregado al carrito"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogo"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(child: Text(error))
            : _catalogoUI(),
      ),
    );
  }
}
