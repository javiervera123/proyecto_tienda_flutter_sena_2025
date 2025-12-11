import 'package:flutter/material.dart';

class BuscadorWidget extends StatelessWidget {
  final Function(String)? onChanged;

  const BuscadorWidget({super.key, this.onChanged, required Null Function(dynamic texto) onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Buscar productos...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
