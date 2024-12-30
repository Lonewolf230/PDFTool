import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdftool/utilities/crop_image.dart';
import 'package:pdftool/utilities/image_service.dart';

class ImageDisplay extends StatefulWidget {
  const ImageDisplay({super.key});

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  final ImageService _imageService = ImageService();
  final CropImage _cropImage = CropImage();
  final List<File> paths = [];

  void displayImage(BuildContext context) async {
    final path = await _imageService.takePicture();
    if (path.isNotEmpty) {
      final String croppedPath = await _cropImage.cropImage(path);
      if (croppedPath.isNotEmpty) {
        // Add this check
        setState(() {
          paths.add(File(croppedPath));
        });
      }
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No Image Selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Display'),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                displayImage(context);
              },
            ),
          ],
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            key: GlobalKey(),
            itemCount: paths.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Image.file(
                      paths[index],
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                      child: Text(
                    paths[index].path,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ))
                ],
              );
            }));
  }
}
