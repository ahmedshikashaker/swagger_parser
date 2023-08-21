import 'dart:convert';

///json_to_dto extension on String
extension JsonToDTOStrings on String {
  ///Converts a JSON string to a Dart PODO DTO class. This assumes that the JSON string
  ///is a valid JSON object. If it is not, an exception will be thrown.
  String toDtoDart([String className = 'Root']) =>
      (jsonDecode(this) as Map<String, dynamic>).toDtoDart(className);
}

///json_to_dto extension on String
extension JsonMapExtension on Map<String, dynamic> {
  ///Converts a Map<String,dynamic> to a Dart PODO DTO class.
  String toDtoDart([String className = 'Root']) {
    final buffer = StringBuffer()..writeln();
    final generatedClasses = <String>{};
    buffer
      ..writeln('''import 'package:json_annotation/json_annotation.dart'; ''')
      ..writeln('''part '${className.toLowerCase()}.g.dart'; ''')
      ..writeln();
    _generateClass(buffer, className, this, generatedClasses);

    return buffer.toString();
  }
}

void _generateClass(
  StringBuffer buffer,
  String className,
  Map<String, dynamic> jsonMap,
  Set<String> generatedClasses,
) {
  if (generatedClasses.contains(className)) return;

  generatedClasses.add(className);

  buffer
    ..writeln('@JsonSerializable()')
    ..writeln('class $className {');

  jsonMap.forEach((key, dynamic value) {
    final type = _getType(value, key);
    buffer.writeln('  final $type? $key;');
  });

  // Unnamed constructor
  buffer
    ..writeln()
    ..writeln('  $className({')
    ..writeAll(jsonMap.entries.map((e) => 'this.${e.key}, '))
    ..writeln('});')
    ..writeln()
    // fromJson factory method
    ..writeln()
    ..writeln('  factory $className.fromJson(Map<String, dynamic> json) =>')
    ..writeln('  _\$${className}FromJson(json);') // toJson method
    ..writeln()
    ..writeln('  Map<String, dynamic> toJson() =>')
    ..writeln('  _\$${className}ToJson(this);') // toJson method
    ..writeln('}')
    ..writeln();

  jsonMap.forEach((key, dynamic value) {
    if (value is Map<String, dynamic>) {
      _generateClass(buffer, _getType(value, key), value, generatedClasses);
    } else if (value is List) {
      if (value.isNotEmpty && value.first is Map) {
        _generateClass(
          buffer,
          _getType(value.first, key),
          value.first as Map<String, dynamic>,
          generatedClasses,
        );
      }
      for (final element in value) {
        if (element is Map<String, dynamic>) {
          _generateClass(
            buffer,
            _getType(element, key),
            element,
            generatedClasses,
          );
        }
      }
    }
  });
}

String _getType(dynamic value, String key) {
  if (value is int) {
    return 'int';
  } else if (value is double) {
    return 'double';
  } else if (value is String) {
    return 'String';
  } else if (value is bool) {
    return 'bool';
  } else if (value is List) {
    if (value.isEmpty) {
      return 'List<dynamic>';
    } else {
      return 'List<${_getType(value.first, key)}>';
    }
  } else if (value is Map) {
    return _capitalize(key);
  } else {
    return 'dynamic';
  }
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
