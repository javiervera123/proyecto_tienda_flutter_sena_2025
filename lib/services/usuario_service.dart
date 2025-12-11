import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioService {
  final String baseUrl = "http://10.0.2.2:3000"; // Para Android Emulator

  Future<Map<String, dynamic>> login(String usuario, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login"); //  esta ruta existe en el backend

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username_credenciales": usuario,
          "password_credenciales": password,
        }),
      );

      if (resp.statusCode == 200) {
        return jsonDecode(resp.body);
      } else {
        return {"success": false, "message": "Error en el servidor"};
      }
    } catch (e) {
      return {"success": false, "message": "Sin conexión con el servidor"};
    }
  }
}
