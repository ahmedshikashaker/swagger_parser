import '../../../swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateDataSourceCode(
    {required String serviceName,
      required String modelName,
      required APIMethodType apiMethod,
      required JsonDtoOutputModel response,

      required String requestModelName}) {

  final serviceReturnModel  = getReturnDataModel(modelName , response);

  return '''
import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
${apiMethod.hasBody() ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}
      
abstract class ${modelName.toPascal}RemoteDataSource {

  Future<$serviceReturnModel> ${apiMethod.getFunctionName().toCamel}${modelName.toPascal}(${apiMethod.hasBody() ? '{required ${requestModelName.toCamel} ${requestModelName.toCamel},${buildPathParameters(serviceName)}}' : "{${buildPathParameters(serviceName)}}"}); 
  
}  
''';
}

