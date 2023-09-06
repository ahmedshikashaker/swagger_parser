import 'package:swagger_parser/swagger_parser.dart';

import '../../utils/case_utils.dart';
import 'api_generator.dart';

String generateStateCode(
    {required String modelName,
    required APIMethodType apiMethod,
    required JsonDtoOutputModel response}) {
  final serviceReturnModel = getReturnDataModel(modelName, response);

  return '''

import 'package:injectable/injectable.dart';
import '../../../data/models/${modelName.toSnake}.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kib_core/kib_core.dart';
part '${modelName.toSnake}.freezed.dart';

@Freezed()
class ${modelName.toPascal}State with _\$${modelName.toPascal}State {
  const factory ${modelName.toPascal}State.initial() = _Initial;

  const factory ${modelName.toPascal}State.loading() = _Loading;
  
  const factory ${modelName.toPascal}State.errors(
      AppExceptions errors, Function callback) = _Errors;
      
  const factory ${modelName.toPascal}State.success${apiMethod.getFunctionName().toPascal}${modelName.toPascal}State(${_getReturnTypeData(serviceReturnModel)}) = _Success${apiMethod.getFunctionName().toPascal}${modelName.toPascal}State;    
      
}
  ''';
}

String _getReturnTypeData(String serviceReturnModel) {
  if (serviceReturnModel != 'void') {
    return serviceReturnModel;
  }

  return '';
}
