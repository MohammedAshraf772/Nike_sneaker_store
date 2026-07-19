import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_sneaker_store/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nike_sneaker_store/features/profile/presentation/widget/view_pohto_dialog.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final String imagePath;

  const ImageSourceBottomSheet({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.image, color: Colors.white),
            title: const Text(
              'View Photo',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => ViewPhotoDialog(imagePath: imagePath),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.white),
            title: const Text(
              'Choose from Gallery',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().pickImageFromGallery();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.white),
            title: const Text(
              'Take Photo',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().pickImageFromCamera();
            },
          ),
        ],
      ),
    );
  }
}
