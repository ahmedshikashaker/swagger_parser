import 'dart:convert';

import '../../utils/case_utils.dart';

class LocalizationGenerator {
  LocalizationGenerator(this.localizationJson);

  final String localizationJson;

  String generateLocalizationVariables()  {
    final map = jsonDecode(localizationJson) as Map<String, dynamic>;
    final linesToWrite = _buildVariables(map);
    return writeLines(variables: linesToWrite);
  }

  List<String> _buildVariables(Map<String, dynamic> map) {
    final linesToWrite = <String>[];
    map.forEach((key, value) {
      if (value is String) {
        final regex = RegExp(r'{(.*?)}');
        if (regex.hasMatch(value)) {
          final matches = regex
              .allMatches(value)
              .toList()
              .map((e) => value.substring(e.start + 1, e.end - 1))
              .toList();
          final str = '''
   String get${key.toPascal}({${matches.map((e) => 'required String $e').toList().join(', ')}}) {
    return '$key'.tr(context: this,namedArgs: {${matches.map((e) => "'$e': $e").toList().join(', ')}});
  }
              ''';
          linesToWrite.add(str);
        } else if (value.contains('{}')) {
          final str =
              " String get${key.toPascal}(List<String> args) {\nreturn '$key'.tr(args: args,context: this);\n}\n";
          linesToWrite.add(str);
        } else {
          final str =
              " String get ${key.toCamel} => tr('$key', context: this);";
          linesToWrite.add(str);
        }
      } else if (value is Map<String, String>) {
        final str =
            "// Available special cases: ${value.keys.join(" or, ")} \n String get${key.toPascal}(String ${key.toCamel}) {\n '$key'.tr(${key.toCamel}: ${key.toCamel} , context: this)\n}\n";
        linesToWrite.add(str);
      }
    });
    return linesToWrite;
  }

  String writeLines({required List<String> variables}) {
    const header = '''
    import 'package:flutter/material.dart';
    import 'package:easy_localization/easy_localization.dart';
    import 'package:kib_core/kib_core.dart';

    
    extension AppLocalization on BuildContext {''';
    const footer = '}';
    final generatedString = variables.join('\n');

    final templateLinesList = [header, generatedString, footer];
    return templateLinesList.join('\n');
  }
}
