import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimo_proyecto/routes/app_routes.dart';
import 'providers/carrito_provider.dart';
// import 'package:ultimo_proyecto/screens/home_screen.dart'; // Ya no se necesita esta importación

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CarritoProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// ---------------------------------------------------------
// WIDGET PRINCIPAL
// ---------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TIENDA VIRTUAL EMILY',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),

      // 💡 CORRECCIÓN: ELIMINAR LA PROPIEDAD 'home'
      // home: const HomeScreen(), // <--- ELIMINADA no se necesita

      initialRoute: AppRoutes.homeScreen, // Usa esta ruta para iniciar
      routes: AppRoutes.routes, // Usa el mapa de rutas
    );
  }
}