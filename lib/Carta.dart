// lib/Carta.dart
class Carta {
  final int? id;
  final String title;
  final String description;
  final DateTime fechaHora;
  final int? userId;

  Carta({this.id, required this.title, required this.description, required this.fechaHora,required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fechaHora': fechaHora.toIso8601String(),
      'userId': userId,
    };
  }

  factory Carta.fromMap(Map<String, dynamic> map) {
    return Carta(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      fechaHora: DateTime.parse(map['fechaHora']),
      userId: map['userId'],
    );
  }
}