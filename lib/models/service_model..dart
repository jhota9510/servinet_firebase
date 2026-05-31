import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;

  // PROVEEDOR
  final String providerId;

  // INFORMACIÓN DEL SERVICIO
  final String title;
  final String description;
  final double basePrice;
  final String categoryId;

  // GALERÍA
  final List<String> images;

  // VISIBILIDAD
  final bool isActive;

  // ESTADÍSTICAS
  final double rating;
  final int totalReviews;
  final int totalBookings;

  // FECHAS
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.categoryId,
    required this.images,
    required this.isActive,
    required this.rating,
    required this.totalReviews,
    required this.totalBookings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ServiceModel(
      id: id,
      providerId: map['providerId'] ?? '',

      title: map['title'] ?? '',
      description: map['description'] ?? '',
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      categoryId: map['categoryId'] ?? '',

      images: List<String>.from(map['images'] ?? []),

      isActive: map['isActive'] ?? true,

      rating: (map['rating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      totalBookings: map['totalBookings'] ?? 0,

      createdAt:
          (map['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),

      updatedAt:
          (map['updatedAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,

      'title': title,
      'description': description,
      'basePrice': basePrice,
      'categoryId': categoryId,

      'images': images,

      'isActive': isActive,

      'rating': rating,
      'totalReviews': totalReviews,
      'totalBookings': totalBookings,

      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ServiceModel copyWith({
    String? id,
    String? providerId,
    String? title,
    String? description,
    double? basePrice,
    String? categoryId,
    List<String>? images,
    bool? isActive,
    double? rating,
    int? totalReviews,
    int? totalBookings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalBookings: totalBookings ?? this.totalBookings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}