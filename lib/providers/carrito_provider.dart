import 'package:flutter/material.dart';
import '../models/producto.dart';

class CarritoProvider extends ChangeNotifier {
  // Lista privada de productos en carrito
  final List<_CarritoItem> _items = [];

  // Exponer lista de productos con cantidad
  List<_CarritoItem> get items => List.unmodifiable(_items);

  // Total considerando cantidad de cada producto
  double get total => _items.fold(
      0, (s, item) => s + (item.producto.precio * item.cantidad));

  // Cantidad total de productos
  int get totalItems =>
      _items.fold(0, (s, item) => s + item.cantidad);

  // ==========================================================
  //  GETTER FALTANTE: itemsAsJson
  // ==========================================================
  // Convierte la lista de items en un formato listo para el backend de Node.js
  List<Map<String, dynamic>> get itemsAsJson {
    // Itera sobre los items locales
    return _items.map((item) => {
      // Usamos las claves que el backend espera recibir:
      'producto_id': item.producto.id,
      'cantidad': item.cantidad,
      'precio_unitario': item.producto.precio,
    }).toList();
  }

  // Agregar producto (si existe, aumenta cantidad)
  void agregarProducto(Producto p) {
    final index = _items.indexWhere((item) => item.producto.id == p.id);
    if (index >= 0) {
      _items[index].cantidad += 1; // aumenta cantidad
    } else {
      _items.add(_CarritoItem(producto: p, cantidad: 1));
    }
    notifyListeners(); // ⚡ importante, notifica cambios a UI
  }

  // Quitar producto (disminuye cantidad, si llega a 0 elimina)
  void eliminarProducto(Producto p) {
    final index = _items.indexWhere((item) => item.producto.id == p.id);
    if (index >= 0) {
      if (_items[index].cantidad > 1) {
        _items[index].cantidad -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Eliminar un producto completamente
  void eliminarProductoCompleto(Producto p) {
    _items.removeWhere((item) => item.producto.id == p.id);
    notifyListeners();
  }

  // Vaciar carrito completo
  void limpiar() {
    _items.clear();
    notifyListeners();
  }
}

// Clase interna para manejar cantidad
class _CarritoItem {
  // Nota: Si producto.id es un String, deberías cambiar el tipo aquí y en el getter itemsAsJson
  final Producto producto;
  int cantidad;

  _CarritoItem({required this.producto, this.cantidad = 1});
}