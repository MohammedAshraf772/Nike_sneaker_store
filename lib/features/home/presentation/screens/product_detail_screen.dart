import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/cart/cubit/cart_cubit.dart';
import 'package:nike_sneaker_store/features/favourates/cubit/favorites_cubit.dart';
import 'package:nike_sneaker_store/features/data/models/product_model.dart';
import 'package:nike_sneaker_store/features/home/data/repo/product_repository.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final repo = ProductRepository();
  ProductModel? fullProduct;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      final result = await repo.getProductById(widget.product.id);
      setState(() {
        fullProduct = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (fullProduct == null) {
      return const Scaffold(body: Center(child: Text("Error loading product")));
    }

    final product = fullProduct!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(product.title),
        actions: [
          BlocBuilder<FavoritesCubit, List<Map<String, dynamic>>>(
            builder: (context, favorites) {
              final isFav = context.watch<FavoritesCubit>().isFavorite(
                product.id,
              );

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  context.read<FavoritesCubit>().toggleFavorite({
                    'id': product.id,
                    'title': product.title,
                    'image': product.image,
                    'price': product.price,
                    'category': product.category,
                  });
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: "product_${product.id}",
              child: Image.network(product.image, height: 250),
            ),

            const SizedBox(height: 16),

            Text(
              product.title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 10),

            Text(product.category, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 10),

            Text(
              "\$${product.price}",
              style: const TextStyle(color: Colors.green, fontSize: 20),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                product.description,
                style: const TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.read<CartCubit>().addToCart(product);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Added to cart")));
              },
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
