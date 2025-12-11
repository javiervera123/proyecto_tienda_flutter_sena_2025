import 'dart:async';
import 'package:flutter/material.dart';
import '../services/categorias_service.dart';
import '../models/categoria_model.dart';
import '../themes/my_theme.dart';

class CategoriasSnapWidget extends StatefulWidget {
  const CategoriasSnapWidget({super.key});

  @override
  _CategoriasSnapWidgetState createState() => _CategoriasSnapWidgetState();
}

class _CategoriasSnapWidgetState extends State<CategoriasSnapWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.32);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) return;

      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: FutureBuilder<List<Categoria>>(
        future: CategoriasService.getCategorias(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categorias = snapshot.data!;

          return PageView.builder(
            controller: _pageController,
            itemCount: categorias.length * 10000, // 🔥 Loop infinito
            itemBuilder: (_, i) {
              final c = categorias[i % categorias.length];

              final url = c.imagen.isEmpty
                  ? "https://via.placeholder.com/200x200.png?text=Sin+Imagen"
                  : (c.imagen.startsWith("http")
                  ? c.imagen
                  : "http://10.0.2.2:3000/uploads/categorias/${c.imagen}");

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(url),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.nombre,
                    textAlign: TextAlign.center,
                    style: MisFuentes.cuerpo.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
