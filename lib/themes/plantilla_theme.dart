import 'package:flutter/material.dart';

// ***************************************
// *  WIDGET: PaginaPrincipal
// *  Pantalla totalmente funcional
// *  - AppBar moderno
// *  - Menú inferior (BottomNavigationBar)
// *  - Botón Flotante con ícono de carrito
// *  - Lista horizontal con puntos y flecha
// *  - Preparada para reutilizar como widget
// ***************************************

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int indexMenu = 0; // controla el menú inferior

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ***************************************
      // * APPBAR SUPERIOR
      // ***************************************
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        title: const Text(
          'Tienda Emily',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications, color: Colors.white),
          )
        ],
      ),

      // ***************************************
      // * CUERPO PRINCIPAL
      // ***************************************
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔍 BUSCADOR SUPERIOR
          _buscador(),
          const SizedBox(height: 20),

          // ⭐ LISTA HORIZONTAL (sin carrusel)
          _tituloSeccion('Productos Recomendados'),
          const SizedBox(height: 12),
          _listaHorizontalConPuntos(),

          const SizedBox(height: 30),
        ],
      ),

      // ***************************************
      // * BOTÓN FLOTANTE (CARRITO)
      // ***************************************
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ***************************************
      // * MENÚ INFERIOR
      // ***************************************
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: Colors.deepPurple,
        child: BottomNavigationBar(
          backgroundColor: Colors.deepPurple,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: indexMenu,
          onTap: (i) {
            setState(() => indexMenu = i);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  // ***************************************
  // * WIDGET BUSCADOR
  // ***************************************
  Widget _buscador() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 3)),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  // ***************************************
  // * TÍTULO DE SECCIÓN
  // ***************************************
  Widget _tituloSeccion(String texto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          texto,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
      ],
    );
  }

  // ***************************************
  // * LISTA HORIZONTAL CON PUNTOS Y FLECHA
  // ***************************************
  Widget _listaHorizontalConPuntos() {
    return Column(
      children: [
        // --- LISTA HORIZONTAL ---
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _cardProducto('assets/huevos.jpg', 'Huevos'),
              _cardProducto('assets/atun.jpg', 'Atún'),
              _cardProducto('assets/pepsi.jpg', 'Pepsi'),
              _cardProducto('assets/pastas.jpg', 'Pastas'),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // --- PUNTOS INDICADORES ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: i == 0 ? Colors.deepPurple : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }

  // ***************************************
  // * CARD DE PRODUCTO
  // ***************************************
  Widget _cardProducto(String img, String titulo) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(2, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(img, height: 100, width: 140, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// --- NUEVA VERSIÓN MÁS COMPLETA DEL WIDGET ---
// Incluye AppBar, menú inferior, botón flotante, lista horizontal con indicadores

class PaginaPrincipalWidget extends StatelessWidget {
  const PaginaPrincipalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- APPBAR ---
      appBar: AppBar(
        title: const Text("Mi Tienda"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),

      // --- BOTÓN FLOTANTE ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- MENÚ INFERIOR ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            IconButton(onPressed: null, icon: Icon(Icons.home)),
            IconButton(onPressed: null, icon: Icon(Icons.person)),
          ],
        ),
      ),

      // --- CUERPO PRINCIPAL ---
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // --- BUSCADOR ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: Icon(Icons.search, color: Colors.pinkAccent),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // --- LISTA HORIZONTAL CON FLECHAS ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {},
              ),

              const Text(
                "Productos Destacados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ],
          ),

          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                5,
                    (index) => Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Item ${index + 1}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // --- INDICADORES (PUNTOS) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
                  (i) => Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: i == 0 ? Colors.purple : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
