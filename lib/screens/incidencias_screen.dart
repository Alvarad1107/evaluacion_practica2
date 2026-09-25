import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/incidencia_service.dart';
import 'detalle_screen.dart';

class IncidenciasScreen extends StatefulWidget {
  const IncidenciasScreen({super.key});

  @override
  _IncidenciasScreenState createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {
  final IncidenciaService _incidenciaService = IncidenciaService();
  late Future<List<Incidencia>> _futureIncidencias;

  @override
  void initState() {
    super.initState();
    _cargarIncidencias();
  }

  // Método para recargar la lista de la base de datos
  void _cargarIncidencias() {
    setState(() {
      _futureIncidencias = _incidenciaService.getIncidencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Incidencias'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarIncidencias, // Botón manual para refrescar
          )
        ],
      ),
      body: FutureBuilder<List<Incidencia>>(
        future: _futureIncidencias,
        builder: (context, snapshot) {
          // 1. Cargando...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          // 2. Error de conexión o de servidor
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          // 3. Lista vacía
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay incidencias registradas.'));
          }

          // 4. Mostrar datos usando ListView.builder como pide el examen
          final incidencias = snapshot.data!;
          return ListView.builder(
            itemCount: incidencias.length,
            itemBuilder: (context, index) {
              final incidencia = incidencias[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    // Le damos color dependiendo de la prioridad para que se vea más profesional
                    backgroundColor: _getColorPrioridad(incidencia.prioridad),
                    child: const Icon(Icons.computer, color: Colors.white),
                  ),
                  // Mínimos solicitados: Nombre, Equipo, Prioridad y Estado
                  title: Text(
                    incidencia.nombreUsuario, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Equipo: ${incidencia.numeroEquipo}'),
                      Text('Prioridad: ${incidencia.prioridad} | Estado: ${incidencia.estado}'),
                    ],
                  ),
                  onTap: () async {
                    // Navega al detalle y espera a ver si fue eliminado/editado
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleIncidenciaScreen(id: incidencia.id!),
                      ),
                    );
                    
                    if (resultado == true) {
                      _cargarIncidencias();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      // Botón flotante opcional por si quieren agregar desde aquí también
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/registro');
          _cargarIncidencias(); // Recarga la lista si agregamos uno nuevo
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Función de apoyo para darle estilo visual a las prioridades
  Color _getColorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Alta': return Colors.red;
      case 'Media': return Colors.orange;
      case 'Baja': return Colors.green;
      default: return Colors.grey;
    }
  }
}