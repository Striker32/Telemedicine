import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarWithPicker extends StatefulWidget {
  final File? initialImage;
  final Function(File) onImageSelected;

  const AvatarWithPicker({
    Key? key,
    required this.onImageSelected,
    this.initialImage,
  }) : super(key: key);

  @override
  _AvatarWithPickerState createState() => _AvatarWithPickerState();
}

class _AvatarWithPickerState extends State<AvatarWithPicker> {

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage; // <--- 3. УСТАНАВЛИВАЕМ НАЧАЛЬНОЕ ИЗОБРАЖЕНИЕ
  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) return;

    final imageFile = File(returnedImage.path);
    setState(() {
      _selectedImage = imageFile;
    });
    widget.onImageSelected(imageFile); // <--- 4. ВОЗВРАЩАЕМ ВЫБРАННЫЙ ФАЙЛ
  }


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: _pickImageFromGallery,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFE0E0E6),
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!)
                : null,
            child: _selectedImage == null
                ? const Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),

          ClipOval(
            child: Container(
              width: 80,
              height: 80,
              color: Colors.black.withOpacity(0.35), // уровень затемнения
            ),
          ),


        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkResponse(
            //onTap: onTap,
            radius: 40,
            containedInkWell: true,
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              // Если хотите, чтобы иконка была в белом круге:
              // child: Container(
              //   width: 36,
              //   height: 36,
              //   decoration: BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
              //   child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              // ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
