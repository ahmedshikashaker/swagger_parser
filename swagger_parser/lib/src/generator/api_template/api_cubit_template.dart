import 'package:swagger_parser/swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateCubitCode(
    {required String modelName,
    required String serviceName,
    required APIMethodType apiMethod,
    required JsonDtoOutputModel response,
    required String requestModelName,
    required bool hasBody,
    required List<String> queryParams}) {
  final serviceReturnModel = getReturnDataModel(modelName, response);

  return '''

import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
import '../../../data/repository/${modelName.toSnake}_usecase.dart';
import '../../../data/repository/${modelName.toSnake}_state.dart';
${hasBody ? "{import '../../../data/models/${modelName.toSnake}_request.dart';" : ""}
  
  
@injectable
class ${modelName.toPascal}Cubit extends Cubit<${modelName.toPascal}State>{

  final ${modelName.toPascal}UseCase _${modelName.toCamel}UseCase;
  
  ${modelName.toPascal}Cubit(this._${modelName.toCamel}UseCase): super(const ${modelName.toPascal}State.initial());
  
  
   ${apiMethod.getFunctionName().toCamel}${modelName.toPascal}(${hasBody ? '{required ${requestModelName.toCamel} ${requestModelName.toCamel},${buildPathParameters(serviceName, queryParams)}}' : "{${buildPathParameters(serviceName, queryParams)}}"}) async {
    
     emit(const  ${modelName.toPascal}State.loading());
       final response = await _${modelName.toCamel}UseCase(
       ${hasBody ? '''${requestModelName.toCamel}:${requestModelName.toCamel},
           ${buildPathParametersValue(serviceName, queryParams)}''' : buildPathParametersValue(serviceName, queryParams)});
    emit(response.fold(
        (error) => ${modelName.toPascal}State.errors(error, ${apiMethod.getFunctionName().toCamel}${modelName.toPascal}),
        (responseData) {
      return ${modelName.toPascal}State.success${apiMethod.getFunctionName().toPascal}${modelName.toPascal}State(${_getReturnTypeData(serviceReturnModel)});
    }));
   }
  ''';
}

String _getReturnTypeData(String serviceReturnModel) {
  if (serviceReturnModel != 'void') {
    return serviceReturnModel;
  }

  return '';
}
