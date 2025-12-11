import 'package:flutter/material.dart';
import '../models/producto.dart';

class CardProducto extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onTap;

  const CardProducto({
    super.key,
    required this.producto,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------
            // 🔵 IMAGEN DEL PRODUCTO (NETWORK)
            // ---------------------------------
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: producto.imagen.isNotEmpty
                  ? Image.network(
                producto.imagen,
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 130,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 45),
                ),
              )
                  : Container(
                height: 130,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 45),
              ),
            ),

            // ---------------------------------
            // 🔵 INFORMACIÓN DEL PRODUCTO
            // ---------------------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟡 NOMBRE
                  Text(
                    producto.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // 🟢 PRECIO
                  Text(
                    "\$${producto.precio.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 🟣 DESCRIPCIÓN (si tiene)
                  if (producto.descripcion.isNotEmpty)
                    Text(
                      producto.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // 🔵 STOCK
                  Text(
                    "Stock: ${producto.stock}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
