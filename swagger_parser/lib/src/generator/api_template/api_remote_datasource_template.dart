import '../../../swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateDataSourceCode(
    {required String modelName,
      required APIMethodType apiMethod,
      required JsonDtoOutputModel response,

      required String requestModelName}) {

  var serviceReturnModel = modelName.toPascal;
  if(response.isArray){
    serviceReturnModel = 'List<${modelName.toPascal}>';
  }



  return '''
  @override
  Future<$serviceReturnModel> ${apiMethod.getName().toCamel}${modelName.toCamel}(${apiMethod.hasBody() ? '${requestModelName.toCamel} ${requestModelName.toCamel}' : ""}) async {
   return await _service.${apiMethod.getName().toCamel}${modelName.toCamel}(${apiMethod.hasBody() ? '${requestModelName.toPascal} ${requestModelName.toPascal}' : ""});
  }
    ''';
}

