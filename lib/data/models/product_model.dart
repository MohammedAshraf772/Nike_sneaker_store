import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // ✅ كل field بيتعامل مع الـ null بأمان
    final rating = json['rating'] as Map<String, dynamic>? ?? {};

    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'No Title',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'uncategorized',
      image: json['image'] as String? ?? '',
      ratingRate: (rating['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: rating['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
    'description': description,
    'image': image,
    'category': category,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    ratingRate,
    ratingCount,
  ];
}
