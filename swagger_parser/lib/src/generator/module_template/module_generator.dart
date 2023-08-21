import 'package:archive/archive.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import '../../utils/case_utils.dart';

class ModuleGenerator {
  static Future<Archive> generateModule(String moduleName) async {
    final byteData = await rootBundle.load('assets/{module_name_snake}.zip');
    final archive = ZipDecoder().decodeBytes(Uint8List.view(byteData.buffer));

    final outArchive = Archive();
    for (final element in archive.files) {
      dynamic content = element.content;
      var size = element.size;
      if (element.isFile) {
        final file = element.content as Uint8List;
        content = String.fromCharCodes(file)
            .replaceAll('{module_name_snake}', moduleName.toSnake)
            .replaceAll('{module_name_pascal}', moduleName.toPascal);
        size = (content as String).length;
      }

      final archiveFile = ArchiveFile(
        element.name.replaceAll('{module_name_snake}', moduleName.toSnake),
        size,
        content,
      );
      outArchive.addFile(archiveFile);
    }

    return outArchive;
  }
}
