import 'package:flutter/material.dart';
import 'screens/inicio_screen.dart'; 
import 'screens/registro_screen.dart'; 
import 'screens/incidencias_screen.dart'; 

void main() {
  runApp(const SoporteApp());
}

class SoporteApp extends StatelessWidget {
  const SoporteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soporte Técnico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PantallaInicio(),
        // Aquí ya conectamos las pantallas reales que creaste
        '/registro': (context) => const RegistrarIncidenciaScreen(),
        '/incidencias': (context) => const IncidenciasScreen(),
      },
    );
  }
}