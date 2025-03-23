class Parish {
  final String id;
  final String name;

  Parish({required this.id, required this.name});

  factory Parish.fromJson(Map<String, dynamic> json) {
    return Parish(id: json['id'] as String, name: json['name'] as String);
  }
}
