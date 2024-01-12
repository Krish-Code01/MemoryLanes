import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final ImagePicker imagePicker = ImagePicker();
  final List<XFile> _pickedImage = [];

  void _selectImage() async {
    _pickedImage.clear();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      _pickedImage.addAll(selectedImages);
    }
    setState(() {});
    widget.onSelectImage(_pickedImage);
  }

  void _deleteImage(int i) {
    _pickedImage.removeAt(i);
    setState(() {});
    widget.onSelectImage(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black54),
        elevation: MaterialStateProperty.all(5),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      onPressed: _selectImage,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text(
            "Add Images",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.photo_library_rounded),
        ],
      ),
    );
  }
}
