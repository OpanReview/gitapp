import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

pickImage(ImageSource source) async {
  final ImagePicker _imagepicker = ImagePicker();

  XFile? _file = await _imagepicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
