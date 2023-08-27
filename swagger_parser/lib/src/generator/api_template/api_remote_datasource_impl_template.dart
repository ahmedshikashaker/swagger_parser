import '../../../swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateDataSourceImplCode(
    {required String modelName,
      required String serviceName,
      required APIMethodType apiMethod,
      required JsonDtoOutputModel response,
      required String requestModelName,
      required List<String> queryParams ,
      required bool hasBody
    
    }) {

  final serviceReturnModel  = getReturnDataModel(modelName , response);

  return '''

import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
import '../../../data/remote/service/${modelName.toSnake}_service.dart';
import '../../../data/remote/datasource/${modelName.toSnake}_remote_datasource.dart';
${hasBody ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}
 
@Injectable(as: ${modelName.toPascal}RemoteDataSource)     
class ${modelName.toPascal}RemoteDataSourceImpl extends ${modelName.toPascal}RemoteDataSource {
  final ${modelName.toPascal}Service _service;
  
  ${modelName.toPascal}RemoteDataSourceImpl(this._service);
  
  @override
  Future<$serviceReturnModel> ${apiMethod.getFunctionName().toCamel}${modelName.toPascal}(${hasBody
      ? '{required ${requestModelName.toCamel} ${requestModelName.toCamel},${buildPathParameters(serviceName,queryParams)}}' : "{${buildPathParameters(serviceName,queryParams)}}"}) async {
   return await _service.${apiMethod.getFunctionName().toCamel}${modelName.toPascal}(${hasBody
      ? '''${requestModelName.toCamel}:${requestModelName.toCamel},
           ${buildPathParametersValue(serviceName,queryParams)}''' : buildPathParametersValue(serviceName,queryParams)}
          ));
  }
  
}  
    ''';
}

