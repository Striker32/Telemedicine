import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarWithPicker extends StatefulWidget {
  final File? initialImage;
  final Function(File) onImageSelected;
  final Uint8List? firestoreBytes;

  const AvatarWithPicker({
    Key? key,
    required this.onImageSelected,
    this.initialImage,
    this.firestoreBytes,
  }) : super(key: key);

  @override
  _AvatarWithPickerState createState() => _AvatarWithPickerState();
}

class _AvatarWithPickerState extends State<AvatarWithPicker> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;

    final imageFile = File(returnedImage.path);
    setState(() {
      _selectedImage = imageFile;
    });
    widget.onImageSelected(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (_selectedImage != null) {
      provider = FileImage(_selectedImage!);          // новый выбор
    } else if (widget.firestoreBytes != null) {
      provider = MemoryImage(widget.firestoreBytes!); // старый Blob
    }

    return InkWell(
      onTap: _pickImageFromGallery,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFE0E0E6),
            backgroundImage: provider,
            child: provider == null
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
          ClipOval(
            child: Container(
              width: 60,
              height: 60,
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkResponse(
              radius: 30,
              containedInkWell: true,
              customBorder: const CircleBorder(),
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/icons/camera.svg',
                  width: 26,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
