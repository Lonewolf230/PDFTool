import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CropImage {
  Future<String> cropImage(String pickedPath) async {
    print(pickedPath);
    if (pickedPath.isEmpty) {
      return '';
    }

    // File pickedFile = File(pickedPath);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedPath,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              cropStyle: CropStyle.rectangle,
              toolbarTitle: 'Crop Your Image',
              toolbarColor: Colors.greenAccent,
              statusBarColor: Colors.green,
              backgroundColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: false,
              initAspectRatio: CropAspectRatioPreset.original,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ]),
        ]);

    if (croppedFile == null) {
      return '';
    }
    return croppedFile.path;
  }
}
