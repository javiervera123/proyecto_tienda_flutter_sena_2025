import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/home_admin_screen.dart';
import '../screens/inicio_sesion_screen.dart';

class AppRoutes {
  static const homeScreen = '/home_screen';
  static const inicioSesion = '/inicio_sesion_screen';
  static const homeAdminScreen = '/home_admin_screen';

  static Map<String, WidgetBuilder> routes = {
    homeScreen: (context) =>  const HomeScreen(),
    inicioSesion: (context) =>  const InicioSesion(),
    homeAdminScreen: (context) => const HomeAdminScreen(),
  };
}
