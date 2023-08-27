
import 'package:swagger_parser/swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateRepositoryImplCode({required String modelName,
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
import '../../../data/repository/${modelName.toSnake}_repository.dart';
import '../../../data/remote/datasource/${modelName.toSnake}_remote_datasource.dart';
${hasBody ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}
  
  
@Injectable(as: ${modelName.toPascal}Repository)
class ${modelName.toPascal}RepositoryImpl extends ${modelName.toPascal}Repository{

  final ${modelName.toPascal}RemoteDataSource remoteDataSource;
  
  ${modelName.toPascal}RepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Either<AppExceptions, $serviceReturnModel>> ${apiMethod
      .getFunctionName().toCamel}${modelName.toPascal}(${hasBody
      ? '{required ${requestModelName.toCamel} ${requestModelName.toCamel},${buildPathParameters(serviceName,queryParams)}}' : "{${buildPathParameters(serviceName,queryParams)}}"}) async {
    try {
      return right(await remoteDataSource.${apiMethod
      .getFunctionName().toCamel}${modelName.toPascal}(${hasBody
      ? '''${requestModelName.toCamel}:${requestModelName.toCamel},
           ${buildPathParametersValue(serviceName,queryParams)}''' : buildPathParametersValue(serviceName,queryParams)}
       ));
    } on Exception catch (error) {
      return left(AppExceptions.getDioException(error));
    }
  }
  
}  
    ''';
}

