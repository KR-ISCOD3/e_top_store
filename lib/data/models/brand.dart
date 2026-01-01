class Brand {
  final String name;
  final String image;

  Brand({
    required this.name,
    required this.image,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}
