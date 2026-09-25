class Incidencia {
  final int? id;
  final String nombreUsuario;
  final String correo;
  final int numeroEquipo;
  final String descripcion;
  final String prioridad;
  final String estado;
  final String? fechaRegistro; // La base de datos lo genera, por eso puede ser nulo al enviarlo

  Incidencia({
    this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.numeroEquipo,
    required this.descripcion,
    required this.prioridad,
    required this.estado,
    this.fechaRegistro,
  });

  // Para leer datos que vienen de la API
  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      id: json['id'],
      nombreUsuario: json['nombre_usuario'],
      correo: json['correo'],
      numeroEquipo: json['numero_equipo'],
      descripcion: json['descripcion'],
      prioridad: json['prioridad'],
      estado: json['estado'],
      fechaRegistro: json['fecha_registro'],
    );
  }

  // Para enviar datos hacia la API
  Map<String, dynamic> toJson() {
    return {
      'nombre_usuario': nombreUsuario,
      'correo': correo,
      'numero_equipo': numeroEquipo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'estado': estado,
      // No enviamos el ID ni la fecha porque la base de datos los autogenera
    };
  }
}