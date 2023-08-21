import 'package:collection/collection.dart';

import '../../utils/case_utils.dart';
import '../../utils/type_utils.dart';
import '../../utils/utils.dart';
import '../models/programming_lang.dart';
import '../models/universal_request.dart';
import '../models/universal_request_type.dart';
import '../models/universal_rest_client.dart';
import '../models/universal_type.dart';

/// Provides template for generating dart Retrofit client
String dartDataSourceClientTemplate({
  required UniversalRestClient restClient,
  required String name,
}) {
  final sb = StringBuffer(
    '''
${_fileImport(restClient)}
${dartImports(imports: restClient.imports, pathPrefix: '../../models/')}

abstract class ${name}RemoteDataSource {
''',
  );
  for (final request in restClient.requests) {
    sb.write(_toClientFunctions(request));
  }
  sb.write('}\n');
  return sb.toString();
}

String _toClientFunctions(UniversalRequest request) {
  final sb = StringBuffer(
    '''

  Future<${request.returnType == null ? 'void' : request.returnType!.toSuitableType(ProgrammingLanguage.dart)}> ${request.name}(''',
  );
  if (request.parameters.isNotEmpty) {
    sb.write('{\n');
  }
  final sortedByRequired = List<UniversalRequestType>.from(
    request.parameters.sorted((a, b) => a.type.compareTo(b.type)),
  );
  for (final parameter in sortedByRequired) {
    sb.write('${_toParameter(parameter)}\n');
  }
  if (request.parameters.isNotEmpty) {
    sb.write('  });\n');
  } else {
    sb.write(');\n');
  }
  return sb.toString();
}

String _fileImport(UniversalRestClient restClient) => restClient.requests.any(
      (r) => r.parameters.any(
        (e) => e.type.toSuitableType(ProgrammingLanguage.dart) == 'File',
  ),
)
    ? "import 'dart:io';\n\n"
    : '';

String _toParameter(UniversalRequestType parameter) =>
        '    ${parameter.type.isRequired && parameter.type.defaultValue == null ? 'required ' : ''}'
        '${parameter.type.toSuitableType(ProgrammingLanguage.dart)} '
        '${parameter.type.name!.toCamel}${_d(parameter.type)},';

/// return defaultValue if have
String _d(UniversalType t) => t.defaultValue != null
    ? ' = ${t.type.quoterForStringType()}'
    '${t.enumType != null ? '${t.type}.${prefixForEnumItems(t.enumType!, t.defaultValue!)}' : t.defaultValue}'
    '${t.type.quoterForStringType()}'
    : '';