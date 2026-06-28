import 'dart:typed_data';

import 'file_saver_stub.dart'
    if (dart.library.js_util) 'file_saver_web.dart'
    if (dart.library.io) 'file_saver_native.dart';

abstract class FileSaver {
  factory FileSaver() => getFileSaver();

  Future<String> saveImage(Uint8List bytes, String fileName);
}
