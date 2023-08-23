import 'package:archive/archive.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import '../../utils/case_utils.dart';

class FeatureGenerator {
  static Future<Archive> generateFeature(String featureName) async {
    final byteData = await rootBundle.load('assets/{feature_name_snake}.zip');
    final archive = ZipDecoder().decodeBytes(Uint8List.view(byteData.buffer));

    final outArchive = Archive();
    for (final element in archive.files) {
      dynamic content = element.content;
      var size = element.size;
      if (element.isFile) {
        final file = element.content as Uint8List;
        content = String.fromCharCodes(file)
            .replaceAll('{feature_name_snake}', featureName.toSnake)
            .replaceAll('{feature_name_pascal}', featureName.toPascal)
            .replaceAll('{feature_name_camel}', featureName.toCamel);
        size = (content as String).length;
      }

      final archiveFile = ArchiveFile(
        element.name.replaceAll('{feature_name_snake}', featureName.toSnake),
        size,
        content,
      );
      outArchive.addFile(archiveFile);
    }

    return outArchive;
  }
}
