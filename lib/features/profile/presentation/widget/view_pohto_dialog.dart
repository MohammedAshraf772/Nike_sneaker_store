import 'dart:io';
import 'package:flutter/material.dart';

class ViewPhotoDialog extends StatelessWidget {
  final String imagePath;

  const ViewPhotoDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: InteractiveViewer(
        child:
            imagePath.isNotEmpty
                ? Image.file(File(imagePath))
                : const Padding(
                  padding: EdgeInsets.all(40),
                  child: Icon(Icons.person, color: Colors.white, size: 100),
                ),
      ),
    );
  }
}
