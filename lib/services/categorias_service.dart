import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/categoria_model.dart';

class CategoriasService {
  static const String baseUrl = "http://10.0.2.2:3000";

  static Future<List<Categoria>> getCategorias() async {
    try {
      final url = Uri.parse("$baseUrl/categorias");
      final res = await http.get(url);

      print("RESPUESTA BACKEND: ${res.body}");

      if (res.statusCode == 200) {
        List data = json.decode(res.body);
        return data.map((c) => Categoria.fromJson(c)).toList();
      } else {
        throw Exception("Error cargando categorías");
      }
    } catch (e) {
      print("ERROR FLUTTER: $e");
      rethrow;
    }
  }

}
