import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdftool/widgets/loading_screen.dart';
import 'package:pdftool/utilities/create_pdf.dart';
import 'package:pdftool/utilities/cropper_image.dart';
import 'package:pdftool/utilities/image_service.dart';

class ImageDisplay extends StatefulWidget {
  const ImageDisplay({super.key});

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  // final _scrollController = ScrollController();
  final ImageService _imageService = ImageService();
  final CropperImage _cropImage = CropperImage();
  final CreatePdf _pdfCreator = CreatePdf();
  List<Map<String, dynamic>> imageWidgets = [];
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _createPdf() async {
    if (imageWidgets.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images to create PDF')),
      );
      return;
    }

    List<File> images = imageWidgets
        .where((image) => image['path'] != null)
        .map((image) => File(image['path']))
        .toList();

    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid images found')),
      );
      return;
    }

    setState(() {
      loading = true;
    });
    try {
      String savedPath = await _pdfCreator.createPdf(images);
      setState(() {
        loading = false;
      });

      if (!context.mounted) return;

      if (savedPath.isNotEmpty) {
        await OpenFilex.open(savedPath);

        if (mounted) Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create PDF')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      if (context.mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occured: Cannot create Pdf')));
    }
  }

  void displayImage(BuildContext context) async {
    final path = await _imageService.takePicture();
    if (path.isNotEmpty) {
      if (!context.mounted) return;
      final String croppedPath = await _cropImage.cropImage(path, context);
      if (croppedPath.isNotEmpty) {
        setState(() {
          final imageWidget = Image.file(
            File(croppedPath),
            fit: BoxFit.cover, // Ensures consistent display
          );
          imageWidgets.add({
            'widget': imageWidget,
            'key': DateTime.now().microsecondsSinceEpoch.toString(),
            'path': croppedPath
          });
        });
      }
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No Image Selected')));
    }
  }

  void _selectImages(BuildContext context) async {
    final paths = await _imageService.selectPictures();
    if (!context.mounted) return;

    for (String path in paths) {
      if (path.isNotEmpty) {
        final String croppedPath = await _cropImage.cropImage(path, context);
        if (croppedPath.isNotEmpty) {
          setState(() {
            final imageWidget = Image.file(
              File(croppedPath),
              fit: BoxFit.cover, // Ensures consistent display
            );
            imageWidgets.add({
              'widget': imageWidget,
              'key': DateTime.now().microsecondsSinceEpoch.toString(),
              'path': croppedPath
            });
          });
        }
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Image Selected')));
      }
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
          IconButton(
              onPressed: () {
                _selectImages(context);
              },
              icon: const Icon(Icons.photo))
        ],
      ),
      body: imageWidgets.isEmpty
          ? const Center(
              child: Text('Select images from gallery or camera'),
            )
          : Stack(children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ReorderableListView.builder(
                  // buildDefaultDragHandles: false, // Use custom drag handles
                  itemCount: imageWidgets.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = imageWidgets.removeAt(oldIndex);
                      imageWidgets.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(imageWidgets[index]['key']),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          imageWidgets.removeAt(index);
                        });
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Container(
                            height: 150,
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: imageWidgets[index]
                                ['widget'], // Display image
                          ),
                          trailing: ReorderableDragStartListener(
                              index: index,
                              child: Text(
                                'Page No ${index + 1}',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _createPdf();
                    },
                    icon: Icon(Icons.create),
                    label: Text('Create PDF'),
                  ),
                ),
              ),
              if (loading)
                Positioned.fill(
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    child: LoadingScreen(),
                  ),
                )
            ]),
    );
  }
}
