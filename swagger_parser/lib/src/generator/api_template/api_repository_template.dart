
import 'package:swagger_parser/swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateRepositoryCode({required String modelName,
  required APIMethodType apiMethod,
  required JsonDtoOutputModel response,
  required String requestModelName}) {
  var serviceReturnModel = modelName.toPascal;
  if (response.isArray) {
    serviceReturnModel = 'List<${modelName.toPascal}>';
  }

  return '''
     @override
  Future<Either<AppExceptions, $serviceReturnModel>> ${apiMethod
      .getName().toCamel}${modelName.toPascal}(${apiMethod.hasBody()
      ? '${requestModelName.toPascal} ${requestModelName.toCamel}'
      : ""}) async {
    try {
      return right(await remoteDataSource.${apiMethod
      .getName().toCamel}${modelName.toPascal}(${apiMethod.hasBody()
      ? '${requestModelName.toPascal} ${requestModelName.toCamel}'
      : ""}));
    } on Exception catch (error) {
      return left( AppExceptions.remote(
          message: "error fetching ${modelName.toPascal} data", statusCode: "-1"));
    }
  }
    ''';
}

