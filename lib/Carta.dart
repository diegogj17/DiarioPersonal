class Carta {
  final int? id;
  final String title;
  final String description;

  Carta({this.id,required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory Carta.fromMap(Map<String, dynamic> map) {
    return Carta(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}