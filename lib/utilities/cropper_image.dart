// import 'dart:async';
// import 'dart:ui' as ui;
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:crop_image/crop_image.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdftool/utilities/storage_permissions_handler.dart';

// class CropperImage {
//   // Future<String> cropImage(String sourcePath, BuildContext context) async {
//   //   if (!context.mounted) return '';

//   //   final granted = await _requestPermissions();
//   //   if (!granted) {
//   //     print('Storage permission denied');
//   //     return '';
//   //   }

//   //   if (!context.mounted) return '';

//   //   final String? croppedPath = await showDialog<String>(
//   //       context: context,
//   //       builder: (BuildContext dialogContext) {
//   //         final controller = CropController(
//   //             defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9));

//   //         return Dialog(
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               AppBar(
//   //                 title: const Text('Crop Image'),
//   //                 actions: [
//   //                   IconButton(
//   //                       onPressed: () async {
//   //                         try {
//   //                           final croppedImage =
//   //                               await controller.croppedImage();
//   //                           final data = await _imageToBytes(croppedImage);
//   //                           // final directory = await getTemporaryDirectory();
//   //                           // final timestamp =
//   //                           //     DateTime.now().microsecondsSinceEpoch;

//   //                           final savePath = await _saveImageToGallery(data);

//   //                           if (dialogContext.mounted) {
//   //                             Navigator.pop(dialogContext, savePath ?? '');
//   //                           }
//   //                         } catch (e) {
//   //                           print('Error saving cropped image:$e');
//   //                           if (dialogContext.mounted) {
//   //                             Navigator.pop(dialogContext, '');
//   //                           }
//   //                         }
//   //                       },
//   //                       icon: Icon(Icons.check))
//   //                 ],
//   //               ),
//   //               Expanded(
//   //                   child: CropImage(
//   //                 image: Image.file(File(sourcePath)),
//   //                 controller: controller,
//   //               ))
//   //             ],
//   //           ),
//   //         );
//   //       });
//   //   if (context.mounted) {
//   //     return croppedPath ?? '';
//   //   }
//   //   return '';
//   // }
//   Future<String> cropImage(String sourcePath, BuildContext context) async {
//     if (!context.mounted) return '';

//     final granted = await _requestPermissions();
//     if (!granted) {
//       print('Storage permission denied');
//       return '';
//     }

//     // Check mounted again after permissions check
//     if (!context.mounted) return '';

//     try {
//       // Store the dialog future result immediately
//       final dialogFuture = showDialog<String>(
//         context: context,
//         builder: (BuildContext dialogContext) {
//           final controller = CropController(
//               defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9));

//           return Dialog(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AppBar(
//                   title: const Text('Crop Image'),
//                   actions: [
//                     IconButton(
//                         onPressed: () => _handleCrop(dialogContext, controller),
//                         icon: const Icon(Icons.check))
//                   ],
//                 ),
//                 Expanded(
//                     child: CropImage(
//                   image: Image.file(File(sourcePath)),
//                   controller: controller,
//                 ))
//               ],
//             ),
//           );
//         },
//       );

//       // Wait for the dialog and check mounted before returning
//       final result = await dialogFuture;
//       if (!context.mounted) return '';
//       return result ?? '';
//     } catch (e) {
//       print('Error in crop dialog: $e');
//       return '';
//     }
//   }

// // Move the crop handling to a separate method
//   Future<void> _handleCrop(
//       BuildContext dialogContext, CropController controller) async {
//     try {
//       final croppedImage = await controller.croppedImage();
//       final data = await _imageToBytes(croppedImage);
//       final savePath = await _saveImageToGallery(data);

//       if (!dialogContext.mounted) return;
//       Navigator.pop(dialogContext, savePath ?? '');
//     } catch (e) {
//       print('Error saving cropped image: $e');
//       if (dialogContext.mounted) {
//         Navigator.pop(dialogContext, '');
//       }
//     }
//   }

//   Future<String?> _saveImageToGallery(Uint8List imageBytes) async {
//     try {
//       if (Platform.isAndroid) {
//         final directory = await getExternalStorageDirectory();
//         if (directory != null) {
//           final String filePath =
//               '${directory.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
//           final File imageFile = File(filePath);
//           await imageFile.writeAsBytes(imageBytes);
//           return filePath;
//         }
//       }
//     } catch (e) {
//       print('Error saving image: $e');
//     }
//     return null;
//   }

//   Future<Uint8List> _imageToBytes(Image image) async {
//     final completer = Completer<Uint8List>();
//     image.image
//         .resolve(ImageConfiguration.empty)
//         .addListener(ImageStreamListener((ImageInfo info, bool _) async {
//       final data = await info.image.toByteData(format: ui.ImageByteFormat.png);
//       if (data != null) {
//         completer.complete(data.buffer.asUint8List());
//       } else {
//         completer.completeError('Failed to convert image to bytes');
//       }
//     }));
//     return completer.future;
//   }

//   Future<bool> _requestPermissions() async {
//     final permissionHandler = StoragePermissionHandler();
//     try {
//       final hasPermission = await permissionHandler.requestStoragePermissions();
//       if (!hasPermission) {
//         print("Storage permission not granted");
//         await permissionHandler.openSettings();
//       }
//       return hasPermission;
//     } catch (e) {
//       print("Error handling permissions: $e");
//       return false;
//     }
//   }
// }

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdftool/utilities/storage_permissions_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CropperImage {
  Future<String> cropImage(String sourcePath, BuildContext context) async {
    if (!context.mounted) return '';

    final granted = await _requestPermissions();
    if (!granted) {
      print('Storage permission denied');
      return '';
    }

    if (!context.mounted) return '';

    try {
      final dialogFuture = showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) {
          final controller = CropController(
              defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9));

          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('Crop Image'),
                  actions: [
                    IconButton(
                        onPressed: () => _handleCrop(dialogContext, controller),
                        icon: const Icon(Icons.check))
                  ],
                ),
                Expanded(
                    child: CropImage(
                  image: Image.file(File(sourcePath)),
                  controller: controller,
                ))
              ],
            ),
          );
        },
      );

      final result = await dialogFuture;
      if (!context.mounted) return '';
      return result ?? '';
    } catch (e) {
      print('Error in crop dialog: $e');
      return '';
    }
  }

  Future<void> _handleCrop(
      BuildContext dialogContext, CropController controller) async {
    try {
      final croppedImage = await controller.croppedImage();
      final data = await _imageToBytes(croppedImage);
      final savePath = await _saveImageToGallery(data);

      if (!dialogContext.mounted) return;
      Navigator.pop(dialogContext, savePath ?? '');
    } catch (e) {
      print('Error saving cropped image: $e');
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext, '');
      }
    }
  }

  Future<String?> _saveImageToGallery(Uint8List imageBytes) async {
    try {
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final String filePath =
              '${directory.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final File imageFile = File(filePath);
          await imageFile.writeAsBytes(imageBytes);

          // Save the image to the gallery using MediaStore for better access across apps
          final result = await ImageGallerySaver.saveFile(imageFile.path);
          print('Image saved to gallery: $result');

          return filePath; // Return the file path where the image was saved
        }
      }
    } catch (e) {
      print('Error saving image: $e');
    }
    return null;
  }

  Future<Uint8List> _imageToBytes(Image image) async {
    final completer = Completer<Uint8List>();
    image.image
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      final data = await info.image.toByteData(format: ui.ImageByteFormat.png);
      if (data != null) {
        completer.complete(data.buffer.asUint8List());
      } else {
        completer.completeError('Failed to convert image to bytes');
      }
    }));
    return completer.future;
  }

  Future<bool> _requestPermissions() async {
    final permissionHandler = StoragePermissionHandler();
    try {
      final hasPermission = await permissionHandler.requestStoragePermissions();
      if (!hasPermission) {
        print("Storage permission not granted");
        await permissionHandler.openSettings();
      }
      return hasPermission;
    } catch (e) {
      print("Error handling permissions: $e");
      return false;
    }
  }
}
