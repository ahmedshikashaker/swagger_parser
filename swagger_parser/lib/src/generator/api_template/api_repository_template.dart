
import 'package:swagger_parser/swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateRepositoryCode({required String modelName,
  required String serviceName,
  required APIMethodType apiMethod,
  required JsonDtoOutputModel response,
  required String requestModelName,
  required bool hasBody,

  required List<String> queryParams}) {
  final serviceReturnModel  = getReturnDataModel(modelName , response);

  return '''

import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
${hasBody ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}
  
  
abstract class ${modelName.toPascal}Repository{

  Future<Either<AppExceptions, $serviceReturnModel>> ${apiMethod
      .getFunctionName().toCamel}${modelName.toPascal}(${hasBody
      ? '{required ${requestModelName.toCamel} ${requestModelName.toCamel},${buildPathParameters(serviceName,queryParams)}}' : "{${buildPathParameters(serviceName,queryParams)}}"}); 
}  
    ''';
}

