import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:pdftool/utilities/cropper_image.dart';
import 'package:pdftool/utilities/image_service.dart';

class ImageDisplay extends StatefulWidget {
  const ImageDisplay({super.key});

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

// class _ImageDisplayState extends State<ImageDisplay> {
//   final _scrollController = ScrollController();

//   final ImageService _imageService = ImageService();
//   // final CropImage _cropImage = CropImage();
//   final CropperImage _cropImage = CropperImage();
//   List<Map<String, dynamic>> imageWidgets = [];

//   void displayImage(BuildContext context) async {
//     final path = await _imageService.takePicture();
//     if (path.isNotEmpty) {
//       if (!context.mounted) return;
//       final String croppedPath = await _cropImage.cropImage(path, context);
//       if (croppedPath.isNotEmpty) {
//         setState(() {
//           final imageWidget = Image.file(
//             File(croppedPath),
//             height: 200,
//             width: 150,
//           );
//           imageWidgets.add({
//             'widget': imageWidget,
//             'key': DateTime.now().microsecondsSinceEpoch.toString()
//           });
//         });
//       }
//     } else {
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('No Image Selected')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Image Display'),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.camera_alt),
//               onPressed: () {
//                 displayImage(context);
//               },
//             ),
//             IconButton(onPressed: () {}, icon: const Icon(Icons.photo))
//           ],
//         ),
//         body: imageWidgets.isEmpty
//             ? Center(
//                 child: Text('Select images from gallery or camera'),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: ReorderableListView.builder(
//                     itemBuilder: (context, index) {
//                       return Dismissible(
//                         key: ValueKey(imageWidgets[index]['key']),
//                         direction: DismissDirection.horizontal,
//                         onDismissed: (direction) {
//                           setState(() {
//                             imageWidgets.removeAt(index);
//                           });
//                         },
//                         child: Card(
//                           elevation: 4,
//                           child: Padding(
//                             // key: ValueKey(index),
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Expanded(
//                                   child: imageWidgets[index]['widget'],
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Flexible(
//                                     child: Text(
//                                   (index + 1).toString(),
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(fontSize: 20),
//                                 ))
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     itemCount: imageWidgets.length,
//                     onReorder: (oldIndex, newIndex) {
//                       setState(() {
//                         if (oldIndex < newIndex) {
//                           newIndex -= 1;
//                         }
//                         final item = imageWidgets.removeAt(oldIndex);
//                         imageWidgets.insert(newIndex, item);
//                       });
//                     }),
//               ));
//   }
// }

// GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.6,
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20),
//             key: GlobalKey(),
//             itemCount: paths.length,
//             itemBuilder: (context, index) {
//               return Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Expanded(
//                     child: Image.file(
//                       paths[index],
//                       height: 200,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Flexible(
//                       child: Text(
//                     (index + 1).toString(),
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontSize: 10),
//                   ))
//                 ],
//               );
//             })

// ReorderableBuilder.builder(
//           key: GlobalKey(),
//           scrollController: _scrollController,
//           onReorder: (ReorderedListFunction reorderedListFunction) {
//             setState(() {
//               imageWidgets =
//                   reorderedListFunction(imageWidgets) as List<Widget>;
//             });
//           },
//           onDragStarted: (int index) {
//             setState(() {});
//           },
//           onDragEnd: (int index) {
//             setState(() {});
//           },
//           enableDraggable: true,
//           childBuilder: (children) {
//             return Padding(
//               padding: const EdgeInsets.all(12),
//               child: GridView.builder(
//                   controller: _scrollController,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 20,
//                       childAspectRatio: 0.8,
//                       mainAxisSpacing: 10),
//                   itemCount: imageWidgets.length,
//                   itemBuilder: (context, index) {

//                   }),
//             );
//           },
//         )

class _ImageDisplayState extends State<ImageDisplay> {
  // final _scrollController = ScrollController();
  final ImageService _imageService = ImageService();
  final CropperImage _cropImage = CropperImage();
  List<Map<String, dynamic>> imageWidgets = [];

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
            'key': DateTime.now().microsecondsSinceEpoch.toString()
          });
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.photo))
        ],
      ),
      body: imageWidgets.isEmpty
          ? const Center(
              child: Text('Select images from gallery or camera'),
            )
          : Padding(
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
                          child: imageWidgets[index]['widget'], // Display image
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
    );
  }
}
