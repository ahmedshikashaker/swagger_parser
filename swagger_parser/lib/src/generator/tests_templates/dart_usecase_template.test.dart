import 'package:swagger_parser/src/generator/models/universal_rest_client.dart';
import 'package:swagger_parser/src/generator/tests_templates/common_test_functions.dart';
import 'package:swagger_parser/src/utils/utils.dart';

import '../../utils/case_utils.dart';
import '../models/universal_request.dart';


/// Provides template for generating dart Retrofit client
String dartTestUseCasesClientTemplate({
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
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/repository/${restClient.name.toSnake}_repository.dart';
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/domain/${request.name.toSnake}_usecase.dart';
${dartImports(imports: restClient.imports, pathPrefix: '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/models/')}
import '${request.name.toSnake}.test.mocks.dart';



@GenerateMocks([
${restClient.name.toPascal}Repository,
${mockTypes(request)}
], customMocks: [
${customMockTypes(request)}
])
void main() {
  late ${request.name.toPascal}UseCase ${request.name.toCamel}UseCase;
  late Mock${restClient.name.toPascal}Repository mock${restClient.name.toPascal}Repository;


  setUp(() {
    mock${restClient.name.toPascal}Repository = Mock${restClient.name.toPascal}Repository();
    ${request.name.toCamel}UseCase = ${request.name.toPascal}UseCase(mock${restClient.name.toPascal}Repository);
  });


 group('${request.name}', () {
${buildReturnTypeVariable(request)}
${buildFunctionParametersTestData(request)}

    test(
        'should call ${request.name} on ${restClient.name.toPascal}Repository with the correct parameters',
        () async {
         
      when(mock${restClient.name.toPascal}Repository.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      )).thenAnswer((_) async => Right(${buildReturnTypeValue(request)}));

      final result = await ${request.name.toCamel}UseCase(
${buildFunctionParametersBody(request)}
      );
      
      expect(result.isRight(), true);
      expect(result, equals(Right(response)));
      verify(mock${restClient.name.toPascal}Repository.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      ));
      verifyNoMoreInteractions(mock${restClient.name.toPascal}Repository);
    });
    

    test('should throw an exception when ${request.name} fails',
        () async {
        
      final exception = AppExceptions.remote(message: 'Failed', statusCode: "400");
      
      when(mock${restClient.name.toPascal}Repository.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      )).thenAnswer((_) async => Left(exception));

      final result = await ${request.name.toCamel}UseCase(
${buildFunctionParametersBody(request)}
      );

      expect(result.isLeft(), true);
      expect(result, equals(Left(exception)));
      verify(mock${restClient.name.toPascal}Repository.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      ));
      verifyNoMoreInteractions(mock${restClient.name.toPascal}Repository);
    });
  });

}

''');
  return sb.toString();
}
