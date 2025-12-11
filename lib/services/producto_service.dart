import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria_model.dart';
import '../models/producto.dart';

class ProductoService {
  // Nota: Si estás en Android Studio o VSCode, 10.0.2.2 es correcto para localhost.
  final String baseUrl = "http://10.0.2.2:3000";

  /// ==========================================================
  /// OBTENER PRODUCTOS (CORREGIDO)
  /// ==========================================================
  Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/productos"));

      if (response.statusCode != 200) {
        throw Exception("Error al cargar productos. Código: ${response.statusCode}");
      }

      // 1. Decodificar la respuesta JSON en un Map
      final Map<String, dynamic> decodedData = jsonDecode(response.body);

      // 2. CORRECCIÓN CLAVE: Extraer el array de la clave "data"
      // La lista de productos está anidada dentro de la clave 'data' del objeto JSON
      final List productosJson = decodedData['data'] ?? [];

      // 3. Mapear la lista de JSON a objetos Producto
      return productosJson.map((json) => Producto.fromJson(json)).toList();

    } catch (e) {
      // Usamos rethrow para ver el error completo de parseo o de red
      print(" ❌ ERROR obtenerProductos(): $e");
      return [];
    }
  }

  /// ==========================================================
  /// OBTENER CATEGORÍAS
  /// ==========================================================
  /// Obtener categorías
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      final url = Uri.parse("$baseUrl/categorias");
      final res = await http.get(url);

      if (res.statusCode != 200) {
        throw Exception("Error cargando categorías: ${res.statusCode}");
      }

      // NOTA: Asumo que el endpoint /categorias devuelve un array directo, no un objeto anidado
      final List data = jsonDecode(res.body);

      return data.map((json) => Categoria.fromJson(json)).toList();
    } catch (e) {
      print("Error obtenerCategorias(): $e");
      return [];
    }
  }



  /// ==========================================================
  /// CREAR PRODUCTO
  /// ==========================================================
  Future crearProducto({
    required String nombre,
    required String descripcion,
    required double precio,
    required int stock,
    required int categoriaId,
  }) async {
    final url = Uri.parse("$baseUrl/productos");

    final body = {
      "nombre_producto": nombre,
      "descripcion_producto": descripcion,
      "precio_producto": precio,
      "stock_producto": stock,
      "categoria_id_producto": categoriaId,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Producto creado
    } else {
      throw Exception("Error creando producto: ${response.body}");
    }
  }
}