import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/incidencia_service.dart';
import 'editar_screen.dart';

class DetalleIncidenciaScreen extends StatefulWidget {
  final int id; // Recibimos el ID para buscar los datos frescos

  const DetalleIncidenciaScreen({super.key, required this.id});

  @override
  _DetalleIncidenciaScreenState createState() => _DetalleIncidenciaScreenState();
}

class _DetalleIncidenciaScreenState extends State<DetalleIncidenciaScreen> {
  final IncidenciaService _incidenciaService = IncidenciaService();
  late Future<Incidencia> _futureIncidencia;

  @override
  void initState() {
    super.initState();
    _cargarDetalle();
  }

  void _cargarDetalle() {
    setState(() {
      _futureIncidencia = _incidenciaService.getIncidenciaById(widget.id);
    });
  }

  // Lógica para confirmar eliminación (Punto 6 del examen)
  void _confirmarEliminacion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Está seguro de que desea eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancela
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Cierra el diálogo
                await _incidenciaService.deleteIncidencia(widget.id);
                if (!mounted) return;
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registro eliminado'), backgroundColor: Colors.red),
                );
                // Regresa a la lista indicando que debe recargarse (true)
                Navigator.pop(context, true); 
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Íconos requeridos por el examen
  Icon _getIconoPrioridad(String prioridad) {
    if (prioridad == 'Alta') return const Icon(Icons.error, color: Colors.red, size: 40);
    if (prioridad == 'Media') return const Icon(Icons.warning, color: Colors.orange, size: 40);
    return const Icon(Icons.info, color: Colors.green, size: 40);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Incidencia'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Incidencia>(
        future: _futureIncidencia,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró la incidencia.'));
          }

          final incidencia = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(incidencia.nombreUsuario, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            _getIconoPrioridad(incidencia.prioridad),
                          ],
                        ),
                        const Divider(),
                        ListTile(leading: const Icon(Icons.email), title: const Text('Correo'), subtitle: Text(incidencia.correo)),
                        ListTile(leading: const Icon(Icons.computer), title: const Text('Equipo'), subtitle: Text(incidencia.numeroEquipo.toString())),
                        ListTile(leading: const Icon(Icons.description), title: const Text('Descripción'), subtitle: Text(incidencia.descripcion)),
                        ListTile(leading: const Icon(Icons.info_outline), title: const Text('Estado'), subtitle: Text(incidencia.estado)),
                        ListTile(leading: const Icon(Icons.calendar_today), title: const Text('Fecha de registro'), subtitle: Text(incidencia.fechaRegistro ?? 'N/A')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Navega a editar y espera a ver si hubo cambios
                        final actualizado = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditarIncidenciaScreen(incidencia: incidencia)),
                        );
                        if (actualizado == true) _cargarDetalle(); // Recarga si se editó
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _confirmarEliminacion,
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}