import 'package:swagger_parser/src/generator/models/universal_request.dart';
import 'package:swagger_parser/src/generator/models/universal_rest_client.dart';

import '../../utils/case_utils.dart';
import '../../utils/utils.dart';
import '../models/programming_lang.dart';
import '../models/universal_type.dart';

/// Provides template for generating dart DTO using freezed
String dartStateFreezedDtoTemplate({  required UniversalRestClient restClient,
    required String name,}) {
  final className = '${name.toPascal}State';
  final sb = StringBuffer( '''
${_fileImport(restClient)}import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kib_core/kib_core.dart';
${dartImports(imports: restClient.imports, pathPrefix: '../../data/models/')}
part '${className.toSnake}.freezed.dart';

@Freezed()
class $className with _\$$className {
  const factory $className.initial() = _Initial;

  const factory $className.loading() = _Loading;
  
  const factory $className.errors(
      AppExceptions errors, Function callback) = _Errors;
''');

  for (final request in restClient.requests) {
    sb.writeln(_toFreezedFunctions(request , className));
  }
  sb.write('}\n');


  return sb.toString();
}

String _toFreezedFunctions(UniversalRequest request , String className){
  if(request.returnType == null){
    return '''
const factory $className.success${request.name.toPascal}(
      ) = _Success${request.name.toPascal};
    ''';
  }else{
    return '''
const factory $className.success${request.name.toPascal}(${request.returnType!.toSuitableType(ProgrammingLanguage.dart)} responseData
      ) = _Success${request.name.toPascal};
    ''';
  }

}


String _fileImport(UniversalRestClient restClient) => restClient.requests.any(
      (r) => r.parameters.any(
        (e) => e.type.toSuitableType(ProgrammingLanguage.dart) == 'File',
  ),
)
    ? "import 'dart:io';\n\n"
    : '';


