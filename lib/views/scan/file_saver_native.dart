import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'file_saver.dart';

FileSaver getFileSaver() => NativeFileSaver();

class NativeFileSaver implements FileSaver {
  @override
  Future<String> saveImage(Uint8List bytes, String fileName) async {
    // =====================================================
    // Simpan ke Temporary Directory
    //
    // Kalau nanti ingin disimpan permanen,
    // cukup ganti getTemporaryDirectory()
    // menjadi getApplicationDocumentsDirectory()
    // =====================================================

    final directory = await getTemporaryDirectory();

    final pictureDir = Directory('${directory.path}/food_images');

    if (!await pictureDir.exists()) {
      await pictureDir.create(recursive: true);
    }

    final file = File('${pictureDir.path}/$fileName');

    await file.writeAsBytes(bytes);

    return file.path;
  }
}