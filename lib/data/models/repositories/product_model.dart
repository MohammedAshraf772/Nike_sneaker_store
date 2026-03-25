import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> availableSizes;
  final List<String> availableColors;
  final bool isNew;
  final bool isFeatured;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.availableSizes,
    required this.availableColors,
    this.isNew = false,
    this.isFeatured = false,
  });

  // من الـ JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      availableSizes: List<String>.from(json['availableSizes'] as List),
      availableColors: List<String>.from(json['availableColors'] as List),
      isNew: json['isNew'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  // لو محتاج تبعته لـ API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'isNew': isNew,
      'isFeatured': isFeatured,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    description,
    price,
    imageUrl,
    rating,
    reviewCount,
    availableSizes,
    availableColors,
    isNew,
    isFeatured,
  ];
}
