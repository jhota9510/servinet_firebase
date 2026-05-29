class ServiceModel {
  final String id;
  final String providerId;
  final String title;
  final String description;
  final double price;
  final String categoryId;
  final List<String> images;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.images,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceModel(
      id: id,
      providerId: map['providerId'],
      title: map['title'],
      description: map['description'],
      price: map['price'].toDouble(),
      categoryId: map['categoryId'],
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'title': title,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'images': images,
    };
  }
}