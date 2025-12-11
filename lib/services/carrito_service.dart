// services/carrito_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

// ⚠️ IMPORTANTE: Ajusta esta ruta a donde tengas definida tu BASE_URL
// Por ejemplo: '../config/config.dart' o similar.
// Si no tienes un archivo de configuración, define la URL aquí directamente.
// Nota: Si estás en Android Studio o VSCode, 10.0.2.2 es correcto para localhost.
// si es en celular la ip config del equipo.
// en este caso el backend está en railway, un servidor en la nube
const String BASE_URL = "https://proyectotiendafluttersena2025-production.up.railway.app";


class CarritoService {

  /// Llama al endpoint de Node.js /carrito/agregar para insertar o actualizar
  /// un producto en la tabla 'carrito_detalle'.
  Future<void> guardarProductoEnBD({
    required int clienteId,
    required int productoId,
    required int cantidad,
  }) async {
    // La URL debe coincidir con la ruta definida en tu Node.js: /carrito/agregar
    final url = Uri.parse('$BASE_URL/carrito/agregar');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          // El modelo de Node.js espera 'carrito_id', que usaremos para enviar el clienteId
          'carrito_id': clienteId,
          'producto_id': productoId,
          'cantidad': cantidad,
        }),
      );

      final decodedBody = json.decode(response.body);

      // Verificamos el estado 200 (OK) y la bandera 'success' del JSON
      if (response.statusCode == 200 && decodedBody['success'] == true) {
        // La operación fue exitosa
        return;
      }

      // Si el servidor retorna un error (código 500, stock insuficiente, etc.)
      else {
        final errorMessage = decodedBody['error'] ?? 'Fallo desconocido al agregar el producto.';
        print('❌ Error del servidor (Código ${response.statusCode}): $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Captura errores de conexión (servidor apagado, IP incorrecta)
      print('❌ Error de conexión al guardar carrito: $e');
      throw Exception('Fallo de red: El servidor puede estar apagado o la URL es incorrecta.');
    }
  }

// Puedes añadir aquí otras funciones como getCarrito() si las necesitas más adelante
}