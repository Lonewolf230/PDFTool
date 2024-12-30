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
}
