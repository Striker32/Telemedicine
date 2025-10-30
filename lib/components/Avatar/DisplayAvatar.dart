import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class DisplayAvatar extends StatelessWidget {
  final File? image;
  // Можно добавить и другие параметры, например, URL сетевого изображения
  // final String? imageUrl;

  const DisplayAvatar({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: const Color(0xFFE0E0E6),
      backgroundImage: image != null ? FileImage(image!) : null,
      child: image == null
          ? const Icon(Icons.person, size: 40, color: Colors.white)
          : null,
    );
  }
}
