import 'package:swagger_parser/src/generator/models/universal_rest_client.dart';
import 'package:swagger_parser/src/generator/tests_templates/common_test_functions.dart';
import 'package:swagger_parser/src/utils/utils.dart';

import '../../utils/case_utils.dart';
import '../models/universal_request.dart';


/// Provides template for generating dart Retrofit client
String dartTestCubitClientTemplate({
  required UniversalRequest request,
  required UniversalRestClient restClient,
}) {
  final sb = StringBuffer('''
import 'package:common_dependencies/common_dependencies.dart' hide test;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kib_core/kib_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/remote/datasource/${restClient.name.toSnake}_remote_data_source_impl.dart';
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/remote/service/${restClient.name.toSnake}_service.dart';
${dartImports(imports: restClient.imports, pathPrefix: '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/models/')}
${_buildUseCasesImports(restClient)}
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/presentation/cubit/${restClient.name.toSnake}_cubit.dart';
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/presentation/cubit/${restClient.name.toSnake}_state.dart';
import '${request.name.toSnake}.test.mocks.dart';



@GenerateMocks([
${_buildMocksAnnotationObjects(restClient)}
${mockTypes(request)}
], customMocks: [
${customMockTypes(request)}
])
void main() {
  late ${restClient.name.toPascal}Cubit ${restClient.name.toCamel}Cubit;
${_buildInitializeMocksObjects(restClient)}


  setUp(() {
${_buildMocksObjects(restClient)}
${_buildCubitObject(restClient)}
  });


 group('${request.name}', () {
${buildReturnTypeVariable(request)}
${buildFunctionParametersTestData(request)}

    test(
        'should call ${request.name} on ${request.name}UseCase with the correct parameters',
        () async {
         
      when(${request.name.toCamel}UseCase(
${buildFunctionParametersBody(request)}
      )).thenAnswer((_) async => Right(${buildReturnTypeValue(request)}));

      // assert later
      final expected = [
        const ${restClient.name.toPascal}State.loading(),
        ${_getSuccessState(request,restClient.name)},
      ];
      expectLater(${restClient.name.toCamel}Cubit.stream, emitsInOrder(expected));
      
      await ${restClient.name.toCamel}Cubit.${request.name}(
${buildFunctionParametersBody(request)}
      );
    });
    

    test('should throw an exception when ${request.name} fails',
        () async {
        
      final exception = AppExceptions.remote(message: 'Failed', statusCode: "400");
      
       when(${request.name.toCamel}UseCase(
${buildFunctionParametersBody(request)}
       ))
          .thenAnswer((_) async => Left(exception));

      // assert later
      final expected = [
        const ${restClient.name.toPascal}State.loading(),
        ${restClient.name.toPascal}State.errors(exception,${restClient.name.toCamel}Cubit.${request.name}),
      ];
      expectLater(${restClient.name.toCamel}Cubit.stream, emitsInOrder(expected));
      
      await ${restClient.name.toCamel}Cubit.${request.name}(
${buildFunctionParametersBody(request)}
      );
    });
  });

}

''');
  return sb.toString();
}

String _getSuccessState(UniversalRequest request ,String name){
  if(request.returnType == null){
    return 'const ${name.toPascal}State.success${request.name.toPascal}()';
  }else{
    return '${name.toPascal}State.success${request.name.toPascal}(response)';
  }

}
String _buildMocksAnnotationObjects(UniversalRestClient restClient){
  final sb = StringBuffer();
  for (final request in restClient.requests) {
    sb.writeln('''${request.name.toPascal}UseCase,''');
  }
  return sb.toString();
}

String _buildUseCasesImports(UniversalRestClient restClient){
  final sb = StringBuffer();
  for (final request in restClient.requests) {
    sb.writeln('''import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/domain/${request.name.toSnake}_usecase.dart';''');
  }
  return sb.toString();
}

String _buildMocksObjects(UniversalRestClient restClient){
  final sb = StringBuffer();
  for (final request in restClient.requests) {
    sb.writeln('''    ${request.name.toCamel}UseCase = Mock${request.name.toPascal}UseCase();''');
  }
  return sb.toString();
}
String _buildInitializeMocksObjects(UniversalRestClient restClient){
  final sb = StringBuffer();
  for (final request in restClient.requests) {
    sb.writeln('''  late Mock${request.name.toPascal}UseCase ${request.name.toCamel}UseCase;''');
  }
  return sb.toString();
}

String _buildCubitObject(UniversalRestClient restClient){
  final sb = StringBuffer(
    '''    ${restClient.name.toCamel}Cubit = ${restClient.name.toPascal}Cubit('''
  );
  for (final request in restClient.requests) {
    sb.writeln('''      ${request.name.toCamel}UseCase,''');
  }
  sb.writeln('    );');
  return sb.toString();
}





