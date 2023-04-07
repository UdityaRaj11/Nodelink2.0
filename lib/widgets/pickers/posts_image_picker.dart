import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PostsImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  PostsImagePicker(this.imagePickFn);

  @override
  State<PostsImagePicker> createState() => _PostsImagePickerState();
}

class _PostsImagePickerState extends State<PostsImagePicker> {
  File? _pickedImage;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
      maxHeight: 420,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: 400,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: _pickedImage != null
                ? Image.file(
                    _pickedImage as File,
                    fit: BoxFit.cover,
                  )
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 7,
            margin: const EdgeInsets.all(10),
          ),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
