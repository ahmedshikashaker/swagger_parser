import '../../../swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateUseCaseFiles(
    {
      required String modelName,
      required String serviceName,
      required APIMethodType method,
      required JsonDtoOutputModel response,
      required String requestModelName,
      required bool hasBody,
      required List<String> queryParams})  {

  final serviceReturnModel  = getReturnDataModel(modelName , response);


  final template = '''

import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
import '../../../data/repository/${modelName.toSnake}_repository.dart';
${hasBody ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}


@injectable
class ${modelName.toPascal}UseCase{

  final ${modelName.toPascal}Repository _repository;

  const ${modelName.toPascal}UseCase(this._repository);

    Future<Either<AppExceptions, $serviceReturnModel>> ${method
      .getFunctionName().toCamel}${modelName.toPascal}(${hasBody
      ? '{required ${requestModelName.toCamel} ${requestModelName.toCamel},${buildPathParameters(serviceName , queryParams)}}' : "{${buildPathParameters(serviceName , queryParams)}}"}) async {
      return _repository.${method
      .getFunctionName().toCamel}${modelName.toPascal}(${hasBody
      ? '''${requestModelName.toCamel}:${requestModelName.toCamel},
           ${buildPathParametersValue(serviceName, queryParams)}''' : buildPathParametersValue(serviceName,queryParams)}
      ));
    }
}
    ''';

  return template;
}
