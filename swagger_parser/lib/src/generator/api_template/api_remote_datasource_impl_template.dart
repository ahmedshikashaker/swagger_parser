import '../../../swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateDataSourceImplCode(
    {required String modelName,
      required String serviceName,
      required APIMethodType apiMethod,
      required JsonDtoOutputModel response,

      required String requestModelName}) {

  final serviceReturnModel  = getReturnDataModel(modelName , response);

  return '''

import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
import '../../../data/remote/service/${modelName.toSnake}_service.dart';
import '../../../data/remote/datasource/${modelName.toSnake}_remote_datasource.dart';
${apiMethod.hasBody() ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}
 
     
class ${modelName.toPascal}RemoteDataSourceImpl extends ${modelName.toPascal}RemoteDataSource {
  final ${modelName.toPascal}Service _service;
  
  ${modelName.toPascal}RemoteDataSourceImpl(this._service);
  
  @override
  Future<$serviceReturnModel> ${apiMethod.getFunctionName().toCamel}${modelName.toPascal}(${apiMethod.hasBody()
      ? '{required ${requestModelName.toCamel} ${requestModelName.toCamel},${buildPathParameters(serviceName)}}' : "{${buildPathParameters(serviceName)}}"}) async {
   return await _service.${apiMethod.getFunctionName().toCamel}${modelName.toPascal}(${apiMethod.hasBody()
      ? '''${requestModelName.toCamel}:${requestModelName.toCamel},
           ${buildPathParametersValue(serviceName)}''' : buildPathParametersValue(serviceName)}
          ));
  }
  
}  
    ''';
}

