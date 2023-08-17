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
String dartCubitClientTemplate({
  required UniversalRestClient restClient,
  required String name,
}) {
  final sb = StringBuffer(
    '''
${_fileImport(restClient)}import 'package:dartz/dartz.dart';
import 'package:kib_core/kib_core.dart';
import 'package:common_dependencies/common_dependencies.dart';
${dartImports(imports: restClient.requests.map((request) => "${request.name.toSnake}_usecase").toSet(), pathPrefix: '../../domain/')}
${dartImports(imports: restClient.imports, pathPrefix: '../../data/models/')}
${dartImports(imports: {'${name}State'.toSnake})}


@Injectable()
class ${name}Cubit extends Cubit<${name.toPascal}State>{
  
''',
  );
  for (final request in restClient.requests) {
    sb.writeln(_getUseCasesFields(request));
  }
  sb.writeln('\n  ${name}Cubit(');
  for (final request in restClient.requests) {
    sb.writeln('    ${_buildCubitParameters(request)}');
  }
  sb.writeln('''
  ): super(const ${name.toPascal}State.initial());
  ''');
  for (final request in restClient.requests) {
    sb.write(_toClientFunctions(request , name));
  }
  sb.write('}\n');
  return sb.toString();
}

String _toClientFunctions(UniversalRequest request , String name) {
  final sb = StringBuffer(
    '''

  Future<void> ${request.name}(''',
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
  sb..writeln(_parseCubitFunctionBody(request ,name ))
    ..writeln('  }');
  return sb.toString();
}

String _getUseCasesFields(UniversalRequest request){
  return '''final ${request.name.toPascal}UseCase _${request.name.toCamel}UseCase;''';
}

String _buildCubitParameters(UniversalRequest request){
  return '''this._${request.name.toCamel}UseCase,''';
}

String _parseCubitFunctionBody(UniversalRequest request ,String name){
  final sb = StringBuffer(
      '''
      emit(const ${name.toPascal}State.loading());
      final response = await _${request.name.toCamel}UseCase(
''');
  final sortedByRequired = List<UniversalRequestType>.from(
    request.parameters.sorted((a, b) => a.type.compareTo(b.type)),
  );
  for (final parameter in sortedByRequired) {
    sb.write('      ${_toParameterBody(parameter)}\n');
  }
  sb..write('    );\n')
  ..write('''
    emit(response.fold(
        (error) => ${name.toPascal}State.errors(error, ${request.name}),
        (responseData) {
      return ${_getSuccessState(request , name)};
    }));
  ''');


  return sb.toString();
}

String _getSuccessState(UniversalRequest request ,String name){
  if(request.returnType == null){
    return 'const ${name.toPascal}State.success${request.name.toPascal}()';
  }else{
    return '${name.toPascal}State.success${request.name.toPascal}(responseData)';
  }

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
