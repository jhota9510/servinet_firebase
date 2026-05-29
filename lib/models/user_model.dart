class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String direccion;

  // SOLO PROVEEDOR
  final String? categoryId;
  final String? experience;
  final String? biography;

  // GENERALES
  final String profileImage;
  final bool verified;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.direccion,
    this.categoryId,
    this.experience,
    this.biography,
    required this.profileImage,
    required this.verified,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      fullName: (map['fullName'] ?? '') as String ,
      email: (map['email'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      role: (map['role'] ?? '') as String,
      direccion: (map['direccion']) as String,
      categoryId: map['categoryId'],
      experience: map['experience'],
      biography: map['biography'],
      profileImage: (map['profileImage'] ?? '') as String,
      verified: map['verified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'direccion':direccion,
      'categoryId': categoryId,
      'experience': experience,
      'biography': biography,
      'profileImage': profileImage,
      'verified': verified,
    };
  }
}
