class Brand {
  final int id;
  final String name;
  final String image;

  Brand({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'] as String,
      // image: json['image'] as String,
      image: json['logo'] ?? '',
    );
  }
}
