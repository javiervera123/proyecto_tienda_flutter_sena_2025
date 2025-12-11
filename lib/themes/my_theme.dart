import 'dart:ui';

import 'package:flutter/material.dart';

class MisColores {
  // background principal
  static const color_primario = Color(
    0xFFB8E8FF,
  ); // static const para aplicar estilo sin crear un objeto
  static const color_secundario = Color(0xFF26A5F4);
  static const color_botones = Color(0xFFF0875D); // color botones
  static const color_interfaz_admin = Colors.white30;
  static const campo_texto = Colors.white30;
  static const texto = Colors.black87;
  static const borde = Colors.amber;
}

class MisFuentes {
  static const TextStyle titulo = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: MisColores.texto,
  );
  static const TextStyle subtitulo = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: MisColores.texto,
  );
  static const TextStyle cuerpo = TextStyle(
    fontSize: 14,
    color: MisColores.texto,
  );

  static const TextStyle boton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class MisBotones {
  // Botón principal
  static ElevatedButton botonPrimario({
    required String texto,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MisColores.color_primario,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(texto, style: MisFuentes.boton),
    );
  }

  // Botón secundario
  static ElevatedButton botonSecundario({
    required String texto,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MisColores.color_secundario,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(texto, style: MisFuentes.boton),
    );
  }

  // FloatingActionButton para carrito
  static FloatingActionButton botonFlotanteCarrito({
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      backgroundColor: MisColores.color_primario,
      onPressed: onPressed,
      child: const Icon(Icons.shopping_cart),
    );
  }
}

class MisCamposTexto {
  static InputDecoration estiloCampo({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: MisFuentes.cuerpo.copyWith(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: MisColores.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: MisColores.borde),
      ),
    );
  }
}

class MisCards {
  static Card cardBasico({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      child: Padding(padding: const EdgeInsets.all(12.0), child: child),
    );
  }
}
