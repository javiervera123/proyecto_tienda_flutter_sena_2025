import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/carrito_provider.dart';

class DetalleProductoScreen extends StatelessWidget {
  final Producto producto; // Solo el producto

  // Constructor corregido
  const DetalleProductoScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(producto.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            producto.imagen.isNotEmpty
                ? Image.network(producto.imagen, height: 200, fit: BoxFit.cover)
                : const Icon(Icons.image, size: 200),
            const SizedBox(height: 20),
            Text(producto.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("\$${producto.precio.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text("Agregar al carrito"),
              onPressed: () {
                carrito.agregarProducto(producto);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${producto.nombre} agregado al carrito"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
