import 'dart:convert';
import 'package:http/http.dart' as http;

class CompraService {
  // Nota: Si estás en Android Studio o VSCode, 10.0.2.2 es correcto para localhost.
  // si es en celular la ip config del equipo.
  // en este caso el backend está en railway, un servidor en la nube
  final String baseUrl = "https://proyectotiendafluttersena2025-production.up.railway.app";

  /// Llama al endpoint de Node.js para procesar la transacción completa.
  /// Acepta el ID del cliente y la lista de productos del carrito.
  Future<Map<String, dynamic>> confirmarCompra(
      int clienteId,
      // Se espera una lista de Map<String, dynamic> del CarritoProvider.itemsAsJson
      List<Map<String, dynamic>> productos
      ) async {
    final url = Uri.parse("$baseUrl/compras/confirmar");

    // Construye el cuerpo de la solicitud JSON
    final body = {
      "cliente_id": clienteId,
      "productos": productos, // ¡Aquí va la lista completa para el backend!
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final decodedResponse = jsonDecode(response.body);

      // Caso 1: Éxito (Código 201 y 'success: true' del backend)
      if (response.statusCode == 201 && decodedResponse['success'] == true) {
        return {
          'success': true,
          'message': decodedResponse['message'],
          'pedido_id': decodedResponse['pedido_id'] // ID del pedido creado
        };
      }

      // Caso 2: Error de negocio (Código 400, ej. Stock insuficiente)
      else if (response.statusCode == 400 || decodedResponse['success'] == false) {
        return {
          'success': false,
          'message': decodedResponse['message'] ?? 'Error desconocido al procesar compra.'
        };
      }

      // Caso 3: Otros errores de servidor (Código 500)
      else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ ERROR en confirmarCompra: $e");
      return {'success': false, 'message': 'Fallo de conexión o servidor no disponible.'};
    }
  }
}