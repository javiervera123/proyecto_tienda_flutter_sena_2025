class Categoria {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final String estado;
  //final String imagenUrl;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.estado,
   // required this.imagenUrl,
  });
  /*factory Categoria.fromJson(Map<String, dynamic> json) {
    print("IMAGEN RECIBIDA: ${json['imagen_categoria']}");

    String imagenPath = json["imagen_categoria"] ?? "";

    if (!imagenPath.startsWith("http")) {
      imagenPath = "http://10.0.2.2:3000/uploads/$imagenPath";
    }

    print("IMAGEN FINAL: $imagenPath");

    return Categoria(
      id: json['id_categoria'],
      nombre: json['nombre_categoria'],
      descripcion: json['descripcion_categoria'] ?? "",
      imagen: imagenPath,
      estado: json['estado'] ?? "ACTIVA",
    );
  }*/

factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id_categoria'],
      nombre: json['nombre_categoria'],
      descripcion: json['descripcion_categoria'] ?? '',
      imagen: json["imagen_categoria"] != null && json["imagen_categoria"] != ""
          ? "http://10.0.2.2:3000/uploads/categorias/${json["imagen_categoria"]}"
          : "",
      estado: json['estado'] ?? 'ACTIVA',
     // imagenUrl: json['imagen_url'] ?? '',
    );
  }
}
