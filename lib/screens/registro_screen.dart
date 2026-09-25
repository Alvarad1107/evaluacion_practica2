import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/incidencia_service.dart';

class RegistrarIncidenciaScreen extends StatefulWidget {
  const RegistrarIncidenciaScreen({super.key});

  @override
  _RegistrarIncidenciaScreenState createState() => _RegistrarIncidenciaScreenState();
}

class _RegistrarIncidenciaScreenState extends State<RegistrarIncidenciaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _equipoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  String _prioridadSeleccionada = 'Baja';
  String _estadoSeleccionado = 'Pendiente';

  final List<String> _opcionesPrioridad = ['Baja', 'Media', 'Alta'];
  final List<String> _opcionesEstado = ['Pendiente', 'En proceso', 'Resuelta'];

  // --- 1. INSTANCIAMOS EL SERVICIO DE LA API ---
  final IncidenciaService _incidenciaService = IncidenciaService();
  bool _isLoading = false; // Variable para mostrar un indicador de carga

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _equipoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // --- 2. FUNCIÓN REAL PARA GUARDAR EN LA BASE DE DATOS ---
  Future<void> _guardarIncidencia() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Muestra el círculo de carga
      });

      try {
        // Armamos el objeto con los datos que escribió el usuario
        final nuevaIncidencia = Incidencia(
          nombreUsuario: _nombreController.text,
          correo: _correoController.text,
          numeroEquipo: int.parse(_equipoController.text),
          descripcion: _descripcionController.text,
          prioridad: _prioridadSeleccionada,
          estado: _estadoSeleccionado,
        );

        // Se lo enviamos a la API de Python
        await _incidenciaService.createIncidencia(nuevaIncidencia);

        if (!mounted) return;

        // Si Python responde bien, mostramos el mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incidencia registrada correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Y lo mandamos directo a la pantalla de lista para que vea el nuevo registro
        Navigator.pushReplacementNamed(context, '/incidencias');

      } catch (e) {
        // Si hay un error, se mostrará en rojo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Oculta el círculo de carga
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Incidencia'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de usuario', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  if (value.length < 3) return 'Debe tener al menos 3 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  if (!value.contains('@') || !value.contains('.')) return 'Ingrese un correo válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _equipoController,
                decoration: const InputDecoration(labelText: 'Número del equipo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.computer)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  final numero = int.tryParse(value);
                  if (numero == null) return 'Solo números';
                  if (numero <= 0) return 'Mayor a 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción de la incidencia', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  if (value.length < 10) return 'Mínimo 10 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _prioridadSeleccionada,
                decoration: const InputDecoration(labelText: 'Prioridad', border: OutlineInputBorder(), prefixIcon: Icon(Icons.warning_amber)),
                items: _opcionesPrioridad.map((String prioridad) => DropdownMenuItem<String>(value: prioridad, child: Text(prioridad))).toList(),
                onChanged: (String? newValue) => setState(() => _prioridadSeleccionada = newValue!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _estadoSeleccionado,
                decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder(), prefixIcon: Icon(Icons.info_outline)),
                items: _opcionesEstado.map((String estado) => DropdownMenuItem<String>(value: estado, child: Text(estado))).toList(),
                onChanged: (String? newValue) => setState(() => _estadoSeleccionado = newValue!),
              ),
              const SizedBox(height: 32),
              
              // --- 3. BOTÓN CON INDICADOR DE CARGA ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _guardarIncidencia,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Registrar Incidencia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}