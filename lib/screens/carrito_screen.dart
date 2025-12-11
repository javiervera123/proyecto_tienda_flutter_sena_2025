import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/carrito_provider.dart';
import '../services/compra_service.dart';
import 'package:ultimo_proyecto/widgets/appbar_principal.dart';

class CarritoScreen extends StatelessWidget {
  // Asegúrate de usar el constructor correcto sin 'const' ya que la propiedad 'compraService' no lo es
  CarritoScreen({super.key});

  // Instancia del servicio
  final CompraService compraService = CompraService();

  // --- Función central que procesa la compra (Definición correcta) ---
  Future<void> _handleCompra(BuildContext context, CarritoProvider carrito) async {

    // Asume el ID del cliente logueado.
    const int clienteId = 1;

    // Obtenemos la lista de productos del Provider
    final productosAComprar = carrito.itemsAsJson;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Procesando compra...')),
    );

    // LLAMAR AL SERVICIO ENVIANDO LA LISTA DE PRODUCTOS
    final resultado = await compraService.confirmarCompra(
        clienteId,
        productosAComprar // Lista de productos para el backend
    );

    // Limpiar SnackBar anterior
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (resultado['success'] == true) {
      // ÉXITO: El backend hizo el COMMIT
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Compra exitosa! Pedido #${resultado['pedido_id']}'),
          backgroundColor: Colors.green,
        ),
      );
      carrito.limpiar();
      Navigator.of(context).popUntil((route) => route.isFirst);

    } else {
      // FALLO: El backend hizo el ROLLBACK (ej. Stock insuficiente)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error en la compra: ${resultado['message']}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();

    return Scaffold(

      body: carrito.items.isEmpty
          ? const Center(child: Text("El carrito está vacío"))
          : Column(
        children: [
          // 1. LISTA DE PRODUCTOS (Parte que faltaba)
          Expanded(
            child: ListView.builder(
              itemCount: carrito.items.length,
              itemBuilder: (context, index) {
                final item = carrito.items[index];
                return ListTile(
                  title: Text(item.producto.nombre),
                  subtitle:
                  Text('Cantidad: ${item.cantidad} - \$${(item.producto.precio * item.cantidad).toStringAsFixed(2)}'),
                  leading: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () =>
                        carrito.eliminarProducto(item.producto),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        carrito.eliminarProductoCompleto(item.producto),
                  ),
                );
              },
            ),
          ),

          // 2. TOTAL Y BOTÓN DE COMPRA (Pie de página)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Total: \$${carrito.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  // Llama a la función correcta para iniciar la transacción
                  onPressed: carrito.items.isEmpty
                      ? null // Deshabilita si está vacío
                      : () => _handleCompra(context, carrito),
                  child: const Text('Comprar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}