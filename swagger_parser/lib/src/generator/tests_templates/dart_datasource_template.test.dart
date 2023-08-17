
import 'package:swagger_parser/src/generator/models/universal_rest_client.dart';
import 'package:swagger_parser/src/generator/tests_templates/common_test_functions.dart';
import 'package:swagger_parser/src/utils/utils.dart';

import '../../utils/case_utils.dart';
import '../models/universal_request.dart';

/// Provides template for generating dart Retrofit client
String dartTestDataSourceImplClientTemplate({
  required UniversalRequest request,
  required UniversalRestClient restClient,
}) {
  final sb = StringBuffer('''
import 'package:common_dependencies/common_dependencies.dart' hide test;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kib_core/kib_core.dart';
import 'package:flutter_test/flutter_test.dart';
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/remote/datasource/${restClient.name.toSnake}_remote_data_source_impl.dart';
import '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/remote/service/${restClient.name.toSnake}_service.dart';
${dartImports(imports: restClient.imports, pathPrefix: '{to_be_replaced_with_feature_path_on_project}/${restClient.name.toSnake}/data/models/')}
import '${request.name.toSnake}.test.mocks.dart';



@GenerateMocks([
${restClient.name.toPascal}Service,
${mockTypes(request)}
], customMocks: [
  ${customMockTypes(request)}
])
void main() {
  late ${restClient.name.toPascal}RemoteDataSourceImpl ${restClient.name.toCamel}RemoteDataSource;
  late Mock${restClient.name.toPascal}Service mock${restClient.name.toPascal}Service;


  setUp(() {
    mock${restClient.name.toPascal}Service = Mock${restClient.name.toPascal}Service();
    ${restClient.name.toCamel}RemoteDataSource = ${restClient.name.toPascal}RemoteDataSourceImpl(mock${restClient.name.toPascal}Service);
  });


 group('${request.name}', () {
${buildReturnTypeVariable(request)}
${buildFunctionParametersTestData(request)}

    test(
        'should call ${request.name} on ${restClient.name.toPascal}Service with the correct parameters',
        () async {
      when(mock${restClient.name.toPascal}Service.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      )).thenAnswer((_) async => ${buildReturnTypeValue(request)});

      final result = await ${restClient.name.toCamel}RemoteDataSource.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      );

      ${_buildResultExpecting(request)}
      verify(mock${restClient.name.toPascal}Service.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      ));
      verifyNoMoreInteractions(mock${restClient.name.toPascal}Service);
    });

    test('should throw an exception when ${request.name} fails',
        () async {
      when(mock${restClient.name.toPascal}Service.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      )).thenThrow(AppExceptions.remote(message: 'Failed', statusCode: "400"));

      expect(
          () => ${restClient.name.toCamel}RemoteDataSource.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      ),
          throwsA(isInstanceOf<AppExceptions>()));
      verify(mock${restClient.name.toPascal}Service.${request.name.toCamel}(
${buildFunctionParametersBody(request)}
      ));
      verifyNoMoreInteractions(mock${restClient.name.toPascal}Service);
    });
  });

}

''');
  return sb.toString();
}

String _buildResultExpecting(UniversalRequest request) {
  if (request.returnType != null) {
    return '''expect(result, equals(response));''';
  }
  return '';
}
