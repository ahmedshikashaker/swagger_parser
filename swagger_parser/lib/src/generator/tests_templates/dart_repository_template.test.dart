import 'package:swagger_parser/src/generator/models/universal_rest_client.dart';
import 'package:swagger_parser/src/generator/tests_templates/common_test_functions.dart';
import 'package:swagger_parser/src/utils/utils.dart';

import '../../utils/case_utils.dart';
import '../models/universal_request.dart';


/// Provides template for generating dart Retrofit client
String dartTestRepositoryImplClientTemplate({
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
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/remote/datasource/${restClient.name.toSnake}_remote_data_source.dart';
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/repository/${restClient.name.toSnake}_repository_impl.dart';
${dartImports(imports: restClient.imports, pathPrefix: '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/models/')}
import '${request.name.toSnake}.test.mocks.dart';



@GenerateMocks([
${restClient.name.toPascal}RemoteDataSource,
${mockTypes(request)}
], customMocks: [
${customMockTypes(request)}
])
void main() {
  late ${restClient.name.toPascal}RepositoryImpl ${restClient.name.toCamel}Repository;
  late Mock${restClient.name.toPascal}RemoteDataSource mock${restClient.name.toPascal}RemoteDataSource;


  setUp(() {
    mock${restClient.name.toPascal}RemoteDataSource = Mock${restClient.name.toPascal}RemoteDataSource();
    ${restClient.name.toCamel}Repository = ${restClient.name.toPascal}RepositoryImpl(mock${restClient.name.toPascal}RemoteDataSource);
  });


 group('${request.name}', () {
${buildReturnTypeVariable(request)}
${buildFunctionParametersTestData(request)}

    test(
        'should call ${request.name} on ${restClient.name.toPascal}RemoteDataSource with the correct parameters',
        () async {
         
      when(mock${restClient.name.toPascal}RemoteDataSource.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      )).thenAnswer((_) async => ${buildReturnTypeValue(request)});

      final result = await ${restClient.name.toCamel}Repository.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      );

      expect(result, equals(Right(response)));
      expect(result.isRight(), true);
      verify(mock${restClient.name.toPascal}RemoteDataSource.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      ));
      verifyNoMoreInteractions(mock${restClient.name.toPascal}RemoteDataSource);
    });
    

    test('should throw an exception when ${request.name} fails',
        () async {
        
      final exception = AppExceptions.remote(message: 'Failed', statusCode: "400");
      
      when(mock${restClient.name.toPascal}RemoteDataSource.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      )).thenThrow(exception);

      final result = await ${restClient.name.toCamel}Repository.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      );

      expect(result.isLeft(), true);
      verify(mock${restClient.name.toPascal}RemoteDataSource.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      ));
      verifyNoMoreInteractions(mock${restClient.name.toPascal}RemoteDataSource);
    });
  });

}

''');
  return sb.toString();
}
