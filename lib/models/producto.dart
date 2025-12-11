class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String imagen; // Este campo ahora contendrá la URL completa
  final String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.imagen,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["id_producto"] ?? 0,
      nombre: json["nombre_producto"]?.toString() ?? "SIN NOMBRE",
      descripcion: json["descripcion_producto"]?.toString() ?? "",
      precio: double.tryParse(json["precio_producto"]?.toString() ?? "0") ?? 0.0,
      stock: int.tryParse(json["stock_producto"]?.toString() ?? "0") ?? 0,

      // ==========================================================
      // 💡 CORRECCIÓN CLAVE: Construir la URL completa de la imagen
      // ==========================================================
      imagen: json["imagen_producto"] != null && json["imagen_producto"] != ""
      // Usamos la IP de Android Emulator y la ruta de productos
          ? "http://10.0.2.2:3000/uploads/productos/${json["imagen_producto"]}"
          : "",

      categoria: json["nombre_categoria"]?.toString() ?? "Sin categoría",
    );
  }
}