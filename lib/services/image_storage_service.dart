import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  /// ==========================================================
  /// Tinggal ganti baris ini kalau nanti mau permanen
  /// ==========================================================
  Future<Directory> _getDirectory() async {
    return await getTemporaryDirectory();

    // NANTI kalau mau permanen cukup ganti menjadi:
    // return await getApplicationDocumentsDirectory();
  }

  Future<String> saveImage(XFile image) async {
    final directory = await _getDirectory();

    final imageFolder = Directory(
      join(directory.path, "food_images"),
    );

    if (!await imageFolder.exists()) {
      await imageFolder.create(recursive: true);
    }

    final filename =
        "${DateTime.now().millisecondsSinceEpoch}.jpg";

    final savedFile = await File(image.path).copy(
      join(imageFolder.path, filename),
    );

    return savedFile.path;
  }

  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clearAllImages() async {
    final directory = await _getDirectory();

    final folder = Directory(
      join(directory.path, "food_images"),
    );

    if (await folder.exists()) {
      await folder.delete(recursive: true);
    }
  }
}