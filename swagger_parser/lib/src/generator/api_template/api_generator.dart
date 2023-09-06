import 'package:swagger_parser/src/generator/api_template/api_remote_datasource_impl_template.dart';
import 'package:swagger_parser/src/generator/api_template/api_repository_impl_template.dart';
import 'package:swagger_parser/src/generator/api_template/api_usecase_template.dart';

import '../../../swagger_parser.dart';
import '../../utils/case_utils.dart';
import 'api_cubit_template.dart';
import 'api_remote_datasource_template.dart';
import 'api_repository_template.dart';
import 'api_service_code_template.dart';
import 'api_state_template.dart';

class APIGenerator {
  APIGenerator();

  Future<ApiGeneratorOutput> generateAPICall(
      {required String modelName,
      required String request,
      required String response,
      required APIMethodType apiMethod,
      required String serviceName,
      required List<String> queryParams}) async {
    String? requestString;
    if (request.isNotEmpty) {
      requestString = _generateModels(
        modelName: '${modelName.toPascal}Request',
        json: request,
      );
    }

    final serviceString = await generateServiceFiles(
        serviceName: serviceName,
        method: apiMethod,
        modelName: modelName,
        response: response.toDtoDart(),
        queryParams: queryParams,
        hasBody: requestString != null && requestString.isNotEmpty);

    final modelString = _generateModels(
      modelName: modelName,
      json: response,
    );

    return ApiGeneratorOutput(
      serviceCode: serviceString,
      modelCode: modelString,
      repositoryCode: generateRepositoryCode(
          modelName: modelName,
          serviceName: serviceName,
          apiMethod: apiMethod,
          response: response.toDtoDart(),
          requestModelName: '${modelName}_request',
          queryParams: queryParams,
          hasBody: requestString != null && requestString.isNotEmpty),
      repositoryImplCode: generateRepositoryImplCode(
          modelName: modelName,
          serviceName: serviceName,
          apiMethod: apiMethod,
          response: response.toDtoDart(),
          requestModelName: '${modelName}_request',
          queryParams: queryParams,
          hasBody: requestString != null && requestString.isNotEmpty),
      dataSourceCode: generateDataSourceCode(
          modelName: modelName,
          serviceName: serviceName,
          apiMethod: apiMethod,
          response: response.toDtoDart(),
          requestModelName: '${modelName}_request',
          queryParams: queryParams,
          hasBody: requestString != null && requestString.isNotEmpty),
      dataSourceImplCode: generateDataSourceImplCode(
          modelName: modelName,
          serviceName: serviceName,
          apiMethod: apiMethod,
          response: response.toDtoDart(),
          requestModelName: '${modelName}_request',
          queryParams: queryParams,
          hasBody: requestString != null && requestString.isNotEmpty),
      useCaseCode: generateUseCaseFiles(
          modelName: modelName,
          serviceName: serviceName,
          method: apiMethod,
          response: response.toDtoDart(),
          requestModelName: '${modelName}_request',
          queryParams: queryParams,
          hasBody: requestString != null && requestString.isNotEmpty),
      cubitCode: generateCubitCode(
        modelName: modelName,
        serviceName: serviceName,
        apiMethod: apiMethod,
        response: response.toDtoDart(),
        requestModelName: '${modelName}_request',
        hasBody: requestString != null && requestString.isNotEmpty,
        queryParams: queryParams,
      ),
      stateCode: generateStateCode(
          apiMethod: apiMethod,
          modelName: modelName,
          response: response.toDtoDart()),
      requestCode: requestString,
    );
  }

  String _generateModels({
    required String modelName,
    required String json,
  }) {
    if (json.isNotEmpty) {
      return json.toDtoDart(modelName).content;
    }
    return '';
  }
}

String getReturnDataModel(String modelName, JsonDtoOutputModel response) {
  if (response.content.isNotEmpty) {
    var serviceReturnModel = modelName.toPascal;
    if (response.isArray) {
      serviceReturnModel = 'List<${modelName.toPascal}>';
    }
    return serviceReturnModel;
  }
  return 'void';
}

String buildPathParameters(String serviceName, List<String> queryParams) {
  final bf = StringBuffer();
  final paths = serviceName.split('/');
  for (final path in paths) {
    if (path.startsWith('{') && path.endsWith('}')) {
      final cleanPath = path.replaceAll('{', '').replaceAll('}', '');
      bf.writeln('''required String $cleanPath,''');
    }
  }
  for (final query in queryParams) {
    bf.writeln('''required String ${query.toCamel},''');
  }
  return bf.toString();
}

String buildServicePathParameters(
    String serviceName, List<String> queryParams) {
  final bf = StringBuffer();
  final paths = serviceName.split('/');
  for (final path in paths) {
    if (path.startsWith('{') && path.endsWith('}')) {
      final cleanPath = path.replaceAll('{', '').replaceAll('}', '');
      bf.writeln('''@Path("$cleanPath") required String $cleanPath,''');
    }
  }
  for (final query in queryParams) {
    bf.writeln('''@Query("$query") required String ${query.toCamel},''');
  }
  return bf.toString();
}

String buildPathParametersValue(String serviceName, List<String> queryParams) {
  final bf = StringBuffer();
  final paths = serviceName.split('/');
  for (final path in paths) {
    if (path.startsWith('{') && path.endsWith('}')) {
      final cleanPath = path.replaceAll('{', '').replaceAll('}', '');
      bf.writeln('''$cleanPath:$cleanPath,''');
    }
  }
  for (final query in queryParams) {
    bf.writeln('''${query.toCamel}:${query.toCamel},''');
  }
  return bf.toString();
}

class ApiGeneratorOutput {
  ApiGeneratorOutput({
    required this.serviceCode,
    required this.modelCode,
    required this.dataSourceCode,
    required this.repositoryCode,
    this.requestCode,
    this.dataSourceImplCode,
    this.repositoryImplCode,
    this.useCaseCode,
    this.cubitCode,
    this.stateCode,
  });

  String serviceCode;
  String modelCode;
  String? requestCode;
  String dataSourceCode;
  String? dataSourceImplCode;
  String repositoryCode;
  String? repositoryImplCode;
  String? useCaseCode;
  String? cubitCode;
  String? stateCode;
}

enum APIMethodType { post, get, update, patch, put, delete }

extension APIMethodTypeEx on APIMethodType {
  String getName() {
    switch (this) {
      case APIMethodType.post:
        return 'POST';
      case APIMethodType.get:
        return 'GET';
      case APIMethodType.put:
        return 'PUT';
      case APIMethodType.update:
        return 'UPDATE';
      case APIMethodType.delete:
        return 'DELETE';
      case APIMethodType.patch:
        return 'PATCH';
    }
  }

  String getFunctionName() {
    switch (this) {
      case APIMethodType.post:
        return 'POST';
      case APIMethodType.get:
        return 'GET';
      case APIMethodType.put:
      case APIMethodType.update:
      case APIMethodType.patch:
        return 'UPDATE';
      case APIMethodType.delete:
        return 'DELETE';
    }
  }

  bool hasBody(String request) {
    return request.isNotEmpty;
  }
}
