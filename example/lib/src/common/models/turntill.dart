class Turntill {
  final int id;
  final String? name;
  final bool isEntry;

  Turntill({
    required this.id,
    required this.name,
    required this.isEntry,
  });

  factory Turntill.fromJson({required Map<String, dynamic> json}) {
    return Turntill(
      name: json['name'] as String?,
      id: json['id'] as int,
      isEntry: json['isEntry'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'isEntry': isEntry,
    };
  }
}
