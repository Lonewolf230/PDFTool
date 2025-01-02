import 'package:image_picker/image_picker.dart';

class ImageService {
  Future<String> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return '';
    }
    return image.path;
  }

  Future<List<String>> selectPictures() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    final List<String> paths = [];
    if (images != null) {
      for (var image in images) {
        if (image.path.isNotEmpty) {
          paths.add(image.path);
        }
      }
    }

    return paths;
  }
}
