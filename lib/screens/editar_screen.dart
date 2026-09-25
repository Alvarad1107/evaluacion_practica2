import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/incidencia_service.dart';

class EditarIncidenciaScreen extends StatefulWidget {
  final Incidencia incidencia; // Recibe la incidencia actual

  const EditarIncidenciaScreen({super.key, required this.incidencia});

  @override
  _EditarIncidenciaScreenState createState() => _EditarIncidenciaScreenState();
}

class _EditarIncidenciaScreenState extends State<EditarIncidenciaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _correoController;
  late TextEditingController _equipoController;
  late TextEditingController _descripcionController;
  late String _prioridadSeleccionada;
  late String _estadoSeleccionado;

  final IncidenciaService _incidenciaService = IncidenciaService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Precargamos los datos en los controladores
    _nombreController = TextEditingController(text: widget.incidencia.nombreUsuario);
    _correoController = TextEditingController(text: widget.incidencia.correo);
    _equipoController = TextEditingController(text: widget.incidencia.numeroEquipo.toString());
    _descripcionController = TextEditingController(text: widget.incidencia.descripcion);
    _prioridadSeleccionada = widget.incidencia.prioridad;
    _estadoSeleccionado = widget.incidencia.estado;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _equipoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _actualizarIncidencia() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final incidenciaEditada = Incidencia(
          nombreUsuario: _nombreController.text,
          correo: _correoController.text,
          numeroEquipo: int.parse(_equipoController.text),
          descripcion: _descripcionController.text,
          prioridad: _prioridadSeleccionada,
          estado: _estadoSeleccionado,
        );

        await _incidenciaService.updateIncidencia(widget.incidencia.id!, incidenciaEditada);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incidencia actualizada correctamente'), backgroundColor: Colors.blue),
        );
        Navigator.pop(context, true); // Retorna a la pantalla de detalle indicando que hubo cambios

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Incidencia'), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mismas validaciones que en registro
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de usuario', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty || value.length < 3 ? 'Mínimo 3 caracteres' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
                validator: (value) => !value!.contains('@') || !value.contains('.') ? 'Correo inválido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _equipoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Equipo', border: OutlineInputBorder()),
                validator: (value) => int.tryParse(value ?? '') == null || int.parse(value!) <= 0 ? 'Solo números > 0' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty || value.length < 10 ? 'Mínimo 10 caracteres' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _prioridadSeleccionada,
                decoration: const InputDecoration(labelText: 'Prioridad', border: OutlineInputBorder()),
                items: ['Baja', 'Media', 'Alta'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _prioridadSeleccionada = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _estadoSeleccionado,
                decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()),
                items: ['Pendiente', 'En proceso', 'Resuelta'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _estadoSeleccionado = v!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _actualizarIncidencia,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15), backgroundColor: Colors.orange, foregroundColor: Colors.white),
                child: _isLoading ? const CircularProgressIndicator() : const Text('Guardar Cambios', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}