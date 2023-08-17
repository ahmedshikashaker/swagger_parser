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
String dartDataSourceImplClientTemplate({
  required UniversalRestClient restClient,
  required String name,
}) {
  final sb = StringBuffer(
    '''
${_fileImport(restClient)}import 'package:common_dependencies/common_dependencies.dart';
${dartImports(imports: restClient.imports, pathPrefix: '../../models/')}
${dartImports(imports: {'${name}RemoteDataSource' })}
${dartImports(imports: {'${name}Service' }, pathPrefix: '../service/')}


@Injectable(as: ${name}RemoteDataSource)
class ${name}RemoteDataSourceImpl implements ${name}RemoteDataSource {
  final ${name}Service _service;

  const ${name}RemoteDataSourceImpl(this._service);
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
  @override
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
    sb.write('  }) async {\n');
  } else {
    sb.write(') async {\n');
  }
  sb..writeln(_parseDataSourceFunctionBody(request))
    ..writeln('  }\n');
  return sb.toString();
}

String _parseDataSourceFunctionBody(UniversalRequest request){
  final sb = StringBuffer(
    '''
    return await _service.${request.name}(
'''
  );
  final sortedByRequired = List<UniversalRequestType>.from(
    request.parameters.sorted((a, b) => a.type.compareTo(b.type)),
  );
  for (final parameter in sortedByRequired) {
    sb.write('  ${_toParameterBody(parameter)}\n');
  }
  sb.write('    );');
return sb.toString();
}

String _fileImport(UniversalRestClient restClient) => restClient.requests.any(
      (r) => r.parameters.any(
        (e) => e.type.toSuitableType(ProgrammingLanguage.dart) == 'File',
  ),
)
    ? "import 'dart:io';\n\n"
    : '';
String _toParameterBody(UniversalRequestType parameter) => '    ${parameter.type.name!.toCamel}:${parameter.type.name!.toCamel},';

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
