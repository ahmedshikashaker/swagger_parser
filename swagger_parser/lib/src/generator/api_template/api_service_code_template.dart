import 'package:swagger_parser/swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

Future<String> generateServiceFiles(
    {required String serviceName,
      required String modelName,
      required JsonDtoOutputModel response,
      required APIMethodType method,
      required bool hasBody,

      required List<String> queryParams
    }) async {

  final serviceReturnModel  = getReturnDataModel(modelName , response);


  final template = '''

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
${hasBody ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}
import 'package:retrofit/retrofit.dart';

part '${modelName.toSnake}_service.g.dart';

@RestApi()
@injectable
abstract class ${modelName.toPascal}Service{
  @factoryMethod
  factory ${modelName.toPascal}Service(Dio dio) = _${modelName.toPascal}Service;

  @${method.getName()}("$serviceName")
  Future<$serviceReturnModel> ${method.getFunctionName().toCamel}${modelName.toPascal.replaceAll("Response", '')}(${hasBody ? '{@Body() required ${modelName}Request ${modelName.toCamel}Request,${buildServicePathParameters(serviceName , queryParams)}}' : '{${buildServicePathParameters(serviceName , queryParams)}}'});
}
    ''';

  return template;
}


