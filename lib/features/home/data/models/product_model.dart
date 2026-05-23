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

  @override
  List<Object?> get props => [id];
}
