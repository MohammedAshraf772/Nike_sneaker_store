import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nike_sneaker_store/core/contants/app_colors.dart';
import 'image_source_bottom_sheet.dart';

class ProfileAvatar extends StatelessWidget {
  final String imagePath;

  const ProfileAvatar({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.card,
              builder: (_) => ImageSourceBottomSheet(imagePath: imagePath),
            );
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade800,
            backgroundImage:
                imagePath.isNotEmpty ? FileImage(File(imagePath)) : null,
            child:
                imagePath.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 18),
          ),
        ),
      ],
    );
  }
}
