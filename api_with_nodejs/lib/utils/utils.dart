import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Utils {
   static Future<File?> pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    return File(image.path);
  }
 
}
