

import '../../../swagger_parser.dart';
import '../../utils/case_utils.dart';
import 'api_remote_datasource_template.dart';
import 'api_repository_template.dart';
import 'api_service_code_template.dart';


class APIGenerator {

  APIGenerator();

  Future<ApiGeneratorOutput> generateAPICall({required String modelName,
    required String request,
    required String response,
    required APIMethodType apiMethod,
    required String serviceName,}) async {
    final serviceString = await generateServiceFiles(
        serviceName: serviceName,
        method: apiMethod,
        modelName: modelName,
        response: response.toDtoDart(),);

    final modelString = _generateModels(
        modelName: modelName, json: response,);
    String? requestString;
    if (request.isNotEmpty) {
      requestString = _generateModels(
          modelName: '${modelName.toPascal}Request', json: request,);
    }

    return ApiGeneratorOutput(
        serviceCode: serviceString,
        modelCode: modelString,
        repositoryCode: generateRepositoryCode(
            modelName: modelName,
            apiMethod: apiMethod,
            response: response.toDtoDart(),
            requestModelName: '${modelName}_request',),
        dataSourceCode: generateDataSourceCode(
            modelName: modelName,
            apiMethod: apiMethod,
            response: response.toDtoDart(),
            requestModelName: '${modelName}_request',),
        requestCode: requestString,);
  }

  String _generateModels(
      {required String modelName, required String json,}) {
    return json.toDtoDart(modelName).content;
  }

  }
class ApiGeneratorOutput {

  ApiGeneratorOutput(
      {required this.serviceCode,
      required this.modelCode,
      required this.dataSourceCode,
      required this.repositoryCode,
      this.requestCode,});
  String serviceCode;
  String modelCode;
  String? requestCode;
  String dataSourceCode;
  String repositoryCode;
}

enum APIMethodType { post, get, update, put, delete }

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
    }
  }

  bool hasBody() {
    switch (this) {
      case APIMethodType.post:
        return true;
      case APIMethodType.get:
        return false;
      case APIMethodType.put:
        return true;
      case APIMethodType.update:
        return true;
      case APIMethodType.delete:
        return false;
    }
  }
}
