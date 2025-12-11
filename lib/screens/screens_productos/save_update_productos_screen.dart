import 'package:flutter/material.dart';
import '../../models/categoria_model.dart';
import '../../services/producto_service.dart';

class SaveUpdateProducto extends StatefulWidget {
  const SaveUpdateProducto({super.key});

  @override
  State<SaveUpdateProducto> createState() => _SaveUpdateProductoState();
}

class _SaveUpdateProductoState extends State<SaveUpdateProducto> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService _service = ProductoService();

  // Campos del formulario
  String nombre = '';
  String descripcion = '';
  double precio = 0.0;
  int stock = 0;
  String codigoBarras = '';
  String codigoInterno = '';
  String imagen = '';
  DateTime? fechaVencimiento;
  Categoria? categoriaSeleccionada;

  // Lista de categorías
  List<Categoria> categorias = [];
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  /// Cargar categorías desde API
  Future<void> _cargarCategorias() async {
    try {
      final lista = await _service.obtenerCategorias();
      setState(() {
        categorias = lista;
      });
    } catch (e) {
      print("Error cargando categorías: $e");
    }
  }

  /// Seleccionar fecha vencimiento
  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        fechaVencimiento = picked;
      });
    }
  }

  /// Guardar producto en BD
  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Seleccione una categoría")));
      return;
    }

    setState(() => cargando = true);

    try {
      await _service.crearProducto(
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        stock: stock,
        categoriaId: categoriaSeleccionada!.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Producto creado correctamente")));

      Navigator.pop(context);
    } catch (e) {
      print("Error creando producto: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error al crear producto")));
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Producto")),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nombre
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nombre del producto",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Campo obligatorio" : null,
                onSaved: (v) => nombre = v ?? "",
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => descripcion = v ?? "",
              ),
              const SizedBox(height: 16),

              // Precio
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Precio",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Ingrese un precio" : null,
                onSaved: (v) =>
                precio = double.tryParse(v ?? "0") ?? 0.0,
              ),
              const SizedBox(height: 16),

              // Stock
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stock",
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => stock = int.tryParse(v ?? "0") ?? 0,
              ),
              const SizedBox(height: 16),

              // Código de barras
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Código de barras",
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => codigoBarras = v ?? "",
              ),
              const SizedBox(height: 16),

              // Código interno
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Código interno",
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => codigoInterno = v ?? "",
              ),
              const SizedBox(height: 16),

              // Imagen
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Imagen (nombre archivo)",
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => imagen = v ?? "",
              ),
              const SizedBox(height: 16),

              // Fecha vencimiento
              Row(
                children: [
                  Expanded(
                    child: Text(
                      fechaVencimiento == null
                          ? "Sin fecha seleccionada"
                          : "Vence: ${fechaVencimiento!.toLocal()}"
                          .split(' ')[0],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _seleccionarFecha,
                    child: const Text("Seleccionar fecha"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Categoría
              DropdownButtonFormField<Categoria>(
                decoration: const InputDecoration(
                  labelText: "Categoría",
                  border: OutlineInputBorder(),
                ),
                items: categorias.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.nombre),
                  );
                }).toList(),
                onChanged: (v) => categoriaSeleccionada = v,
                validator: (v) =>
                v == null ? "Debe seleccionar una categoría" : null,
              ),
              const SizedBox(height: 32),

              // BOTÓN GUARDAR
              ElevatedButton(
                onPressed: _guardarProducto,
                child: const Text("Guardar Producto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
