// widgets/producto_card_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/carrito_provider.dart';

//  servicio para hablar con Node.js
import '../services/carrito_service.dart';

class ProductoCardWidget extends StatelessWidget {
  final Producto producto;

  const ProductoCardWidget({super.key, required this.producto});

  // *************************************************************
  // ⚠️ TEMPORAL: ID del Cliente Fijo.
  // ¡DEBES REEMPLAZAR ESTO CON EL ID DEL USUARIO LOGEADO!
  final int clienteIdTemporal = 1;
  // *************************************************************

  @override
  Widget build(BuildContext context) {
    // Escuchar el provider es innecesario si solo lo usas para llamar a una función
    final carritoProvider = Provider.of<CarritoProvider>(context, listen: false);
    final carritoService = CarritoService(); // Instancia del servicio

    return Container(
      width: 150, // Ancho fijo para el scroll horizontal
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEN
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                producto.imagen,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 100),
              ),
            ),

            // CONTENIDO (Nombre, Precio, Botón)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${producto.precio.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // 🌟 FUNCIÓN ASÍNCRONA MODIFICADA 🌟
                      onPressed: () async {

                        // 1. Lógica del Provider (Actualiza el estado local de la UI)
                        carritoProvider.agregarProducto(producto);

                        try {
                          // 2. 🚀 Lógica del Servicio (Guarda en la base de datos vía Node.js)
                          await carritoService.guardarProductoEnBD(
                            clienteId: clienteIdTemporal,
                            productoId: producto.id,
                            cantidad: 1, // Siempre añadimos 1 unidad por clic
                          );

                          // Mostrar feedback de éxito
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("✅ ${producto.nombre} añadido (Guardado en BD)"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } catch (e) {
                          // Si falla la BD, revertimos el estado local y mostramos error
                          carritoProvider.eliminarProducto(producto); // Revertir

                          String mensajeError = e.toString().contains(":")
                              ? e.toString().split(':')[1]
                              : "Error desconocido del servidor.";

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("❌ ERROR: No se guardó en BD. $mensajeError"),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}