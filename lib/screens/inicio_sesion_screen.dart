import 'package:flutter/material.dart';
import 'package:ultimo_proyecto/screens/home_admin_screen.dart';
import '../services/usuario_service.dart';
import '../widgets/appbar_principal.dart';
import '../themes/my_theme.dart'; // importa tus estilos y colores

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  // Controladores para capturar texto de usuario y contraseña
  final TextEditingController controllerUsuario = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  // Mensaje de error o info
  String mensaje = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPrincipal(), // AppBar personalizado

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // -------------------------------
              // TITULO DE LOGIN
              // -------------------------------
              Text(
                "Iniciar Sesión",
                style: MisFuentes.titulo.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 40),

              // -------------------------------
              // CAMPO DE USUARIO
              // -------------------------------
              TextField(
                controller: controllerUsuario,
                decoration: MisCamposTexto.estiloCampo(hint: "Usuario"),
              ),
              const SizedBox(height: 20),

              // -------------------------------
              // CAMPO DE CONTRASEÑA
              // -------------------------------
              TextField(
                controller: controllerPassword,
                obscureText: true,
                decoration: MisCamposTexto.estiloCampo(hint: "Contraseña"),
              ),
              const SizedBox(height: 30),


              // BOTÓN LOGIN
              // -------------------------------
              MisBotones.botonSecundario(
                texto: "Iniciar Sesión",
                onPressed: () async {
                  final service = UsuarioService();

                  // Llamada al backend
                  final resp = await service.login(
                    controllerUsuario.text.trim(),
                    controllerPassword.text.trim(),
                  );

                  if (resp["success"] == true) {
                    // ✅ Login exitoso: navega a HomeAdminScreen
                    // Eliminando historial para que no se pueda regresar
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home_admin_screen', (route) => false);
                  } else {
                    // ❌ Mostrar mensaje de error
                    setState(() {
                      mensaje = resp["message"] ?? "Error desconocido";
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // -------------------------------
              // MENSAJE DE ERROR O INFO
              // -------------------------------
              if (mensaje.isNotEmpty)
                Text(
                  mensaje,
                  style: MisFuentes.cuerpo.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
