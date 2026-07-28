import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;

  final String title;

  final String image;

  final double price;

  final String category;
  final String description;
  final double ratingRate;
  final int ratingCount;

  const ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    required this.ratingRate,
    required this.ratingCount,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ProductModel(
      id: int.tryParse(doc.id) ?? doc.id.hashCode,
      title: data['title'] as String? ?? '',
      image: data['image'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      category: data['category'] as String? ?? '',
      description: data['description'] as String? ?? '',
      ratingRate: (data['ratingRate'] as num?)?.toDouble() ?? 0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [id];
}
