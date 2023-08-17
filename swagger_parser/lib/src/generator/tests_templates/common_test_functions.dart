import 'package:collection/collection.dart';

import '../../utils/case_utils.dart';
import '../../utils/type_utils.dart';
import '../models/programming_lang.dart';
import '../models/universal_request.dart';
import '../models/universal_request_type.dart';
import '../models/universal_type.dart';

String buildFunctionParametersTestData(UniversalRequest request) {
  final sb = StringBuffer();

  final sortedByRequired = List<UniversalRequestType>.from(
    request.parameters.sorted((a, b) => a.type.compareTo(b.type)),
  );
  for (final parameter in sortedByRequired) {
    sb.writeln(buildMockParameterTypeVariable(parameter));
  }
  return sb.toString();
}

String buildMockParameterTypeVariable(UniversalRequestType parameter) {
    if(parameter.type.arrayDepth > 0){
      return '''    final ${parameter.type.name?.toCamel}  = MockList<${parameter.type.toSuitableListTestType(ProgrammingLanguage.dart)}>();''';
    }else if(parameter.type.enumType!= null){
      return '''    final ${parameter.type.name?.toCamel}  = ${parameter.type.type}.values[0];''';
    } else if(parameter.type.type.isCustomDartType()){
      return '''    final ${parameter.type.name?.toCamel}  = Mock${parameter.type.type}();''';
    }else{
      return '''    final ${parameter.type.name?.toCamel}  = AppFactoryGenerator().get<${parameter.type.type.toDartType()}>();''';
    }
}

String buildFunctionParametersBody(UniversalRequest request) {
  final sb = StringBuffer();
  final sortedByRequired = List<UniversalRequestType>.from(
    request.parameters.sorted((a, b) => a.type.compareTo(b.type)),
  );
  for (final parameter in sortedByRequired) {
    sb.writeln('        ${toParameterBody(parameter)}');
  }
  return sb.toString();
}

String? buildReturnTypeVariable(UniversalRequest request) {
  if (request.returnType != null) {
    if(request.returnType!.arrayDepth > 0){
      return '''    final response = MockList<${request.returnType!.toSuitableListTestType(ProgrammingLanguage.dart)}>();''';
    }else if(request.returnType!.enumType!= null){
      return '''    final response = ${request.returnType!.type}.values[0];''';
    } else if(request.returnType!.type.isCustomDartType()){
      return '''    final response = Mock${request.returnType!.type}();''';
    }else{
      return '''    final response = AppFactoryGenerator().get<${request.returnType!.type.toDartType()}>();''';
    }
  }
  return '    const response = null;';
}

String? mockTypes(UniversalRequest request) {
  final sb = StringBuffer();

  for (final parameter in request.parameters.where((element) =>
      element.type.type.isCustomDartType() && element.type.enumType == null)) {
    sb.writeln('${parameter.type.type},');
  }
  if (request.returnType != null &&
      request.returnType!.type.isCustomDartType() && request.returnType?.enumType == null ){
    sb.writeln('${request.returnType!.type},');
  }
  return sb.toString();
}

String? customMockTypes(UniversalRequest request) {
  final sb = StringBuffer();
  if (request.parameters.any((element) => element.type.arrayDepth > 0) ||
      (request.returnType != null && request.returnType!.arrayDepth > 0)) {
    sb.writeln('''
      MockSpec<List>(
    onMissingStub: OnMissingStub.returnDefault,
  )''');
  }
  return sb.toString();
}

String toParameterBody(UniversalRequestType parameter) =>
    '${parameter.type.name!.toCamel}:${parameter.type.name!.toCamel},';


String? buildReturnTypeValue(UniversalRequest request) {
  return 'response';
}
