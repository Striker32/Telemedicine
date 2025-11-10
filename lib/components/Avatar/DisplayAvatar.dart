import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class DisplayAvatar extends StatelessWidget {
  final File? image;
  final Uint8List? firestoreBytes; // добавили поддержку Blob

  const DisplayAvatar({Key? key, this.image, this.firestoreBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (firestoreBytes != null) {
      provider = MemoryImage(firestoreBytes!);
    } else if (image != null) {
      provider = FileImage(image!);
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: const Color(0xFFE0E0E6),
      backgroundImage: provider,
      child: provider == null
          ? const Icon(Icons.person, size: 30, color: Colors.white)
          : null,
    );
  }
}
