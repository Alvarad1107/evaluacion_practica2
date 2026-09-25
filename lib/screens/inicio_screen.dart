import 'package:flutter/material.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte App'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/soporte.png', 
              height: 150,
              errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Icon(Icons.computer, size: 50, color: Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 30),

            // Texto principal
            const Text(
              'Gestión de Incidencias Técnicas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              'Registra y administra los problemas técnicos detectados en los equipos informaticos para facilitar su seguimiento y atención.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),

            // 5. Botón 1: Registrar incidencias
            SizedBox(
              width: double.infinity, // Hace que el botón ocupe todo el ancho
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navega a la ruta /registro
                  Navigator.pushNamed(context, '/registro');
                },
                label: const Text('Registrar incidencias'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15), // Espacio entre los botones

            // 6. Botón 2: Ver incidencias
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navega a la ruta /incidencias
                  Navigator.pushNamed(context, '/incidencias');
                },
                label: const Text('Ver incidencias'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.deepPurple, // Color distinto para diferenciarlo
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}