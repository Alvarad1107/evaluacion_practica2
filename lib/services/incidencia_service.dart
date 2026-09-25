import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/incidencia.dart';

class IncidenciaService {
  
  // GET: Obtener todas las incidencias (Punto 3 del examen)
  Future<List<Incidencia>> getIncidencias() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/incidencias'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Incidencia.fromJson(item)).toList();
    } else {
      throw Exception('Fallo al cargar incidencias');
    }
  }

  // GET: Obtener una incidencia por ID (Punto 4 del examen)
  Future<Incidencia> getIncidenciaById(int id) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/incidencias/$id'));

    if (response.statusCode == 200) {
      return Incidencia.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar la incidencia');
    }
  }

  // POST: Crear una incidencia (Punto 2 del examen)
  Future<void> createIncidencia(Incidencia incidencia) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/incidencias'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(incidencia.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Fallo al crear la incidencia');
    }
  }

  // PUT: Editar una incidencia (Punto 5 del examen)
  Future<void> updateIncidencia(int id, Incidencia incidencia) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/incidencias/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(incidencia.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Fallo al actualizar la incidencia');
    }
  }

  // DELETE: Eliminar una incidencia (Punto 6 del examen)
  Future<void> deleteIncidencia(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/incidencias/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Fallo al eliminar la incidencia');
    }
  }
}