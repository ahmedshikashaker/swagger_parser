/// Provides generation functions that generates REST clients and data classes from OpenApi definition file
/// [swagger_parser](https://pub.dev/packages/swagger_parser)
library swagger_parser;

export 'package:swagger_parser/src/parser/json_to_dto.dart';

export 'src/generator/api_template/api_generator.dart';
export 'src/generator/generator.dart';
export 'src/generator/models/generated_file.dart';
export 'src/generator/models/programming_lang.dart';
export 'src/generator/module_template/module_generator.dart';
