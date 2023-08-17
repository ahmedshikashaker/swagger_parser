import '../utils/case_utils.dart';
import 'models/generated_file.dart';
import 'models/programming_lang.dart';
import 'models/universal_data_class.dart';
import 'models/universal_rest_client.dart';

/// Handles generating files
class FillController {
  const FillController({
    ProgrammingLanguage programmingLanguage = ProgrammingLanguage.dart,
    String clientPostfix = 'Service',
    bool squishClients = false,
    bool freezed = false,
    bool includeToJsonInEnums = false,
  })  : _clientPostfix = clientPostfix,
        _programmingLanguage = programmingLanguage,
        _squishClients = squishClients,
        _freezed = freezed,
        _includeToJsonInEnums = includeToJsonInEnums;

  final ProgrammingLanguage _programmingLanguage;
  final String _clientPostfix;
  final bool _freezed;
  final bool _squishClients;
  final bool _includeToJsonInEnums;

  /// Return [GeneratedFile] generated from given [UniversalDataClass]
  GeneratedFile fillDtoContent(UniversalDataClass dataClass , String? folderName) {
    final folder = folderName !=null?'features/${folderName.toSnake}/data/models/':'features/shared_models/';
   return GeneratedFile(
      name: '$folder'
          '${_programmingLanguage == ProgrammingLanguage.dart ? dataClass.name
          .toSnake : dataClass.name.toPascal}'
          '.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.dtoFileContent(
        dataClass,
        freezed: _freezed,
        includeToJsonInEnums: _includeToJsonInEnums,
      ),
    );
  }


  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  GeneratedFile fillRestClientContent(UniversalRestClient restClient) {
    final fileName = _programmingLanguage == ProgrammingLanguage.dart
        ? '${restClient.name}_service'.toSnake
        : restClient.name.toPascal + _clientPostfix.toPascal;
    final folderName = _squishClients ? 'clients' : restClient.name.toSnake;
    return GeneratedFile(
      name: 'features/$folderName/data/remote/service/$fileName.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.restClientFileContent(
        restClient,
        '${restClient.name.toPascal}Service',
      ),
    );
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  GeneratedFile fillDataSourceClientContent(UniversalRestClient restClient) {
    final fileName = _programmingLanguage == ProgrammingLanguage.dart
        ? '${restClient.name}_remote_data_source'.toSnake
        : restClient.name.toPascal + _clientPostfix.toPascal;
    final folderName = restClient.name.toSnake;
    return GeneratedFile(
      name: 'features/$folderName/data/remote/datasource/$fileName.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.dataSourceClientFileContent(
        restClient,
        restClient.name.toPascal,
      ),
    );
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  GeneratedFile fillDataSourceImplClientContent(UniversalRestClient restClient) {
    final fileName = _programmingLanguage == ProgrammingLanguage.dart
        ? '${restClient.name}_remote_data_source_impl'.toSnake
        : restClient.name.toPascal + _clientPostfix.toPascal;
    final folderName = restClient.name.toSnake;
    return GeneratedFile(
      name: 'features/$folderName/data/remote/datasource/$fileName.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.dataSourceImplClientFileContent(
        restClient,
        restClient.name.toPascal,
      ),
    );
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  GeneratedFile fillRepositoryClientContent(UniversalRestClient restClient) {
    final fileName = _programmingLanguage == ProgrammingLanguage.dart
        ? '${restClient.name}_repository'.toSnake
        : restClient.name.toPascal + _clientPostfix.toPascal;
    final folderName = restClient.name.toSnake;
    return GeneratedFile(
      name: 'features/$folderName/data/repository/$fileName.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.repositoryClientFileContent(
        restClient,
        restClient.name.toPascal,
      ),
    );
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  List<GeneratedFile> fillUseCasesClientContent(UniversalRestClient restClient) {

    final folderName = restClient.name.toSnake;
    return restClient.requests.map((request) => GeneratedFile(
      name: 'features/$folderName/domain/${request.name.toSnake}_usecase.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.useCaseClientFileContent(
        restClient,
        request,
      ),
    ),).toList();
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  GeneratedFile fillCubitClientContent(UniversalRestClient restClient) {
    final folderName = restClient.name.toSnake;
    return  GeneratedFile(
      name: 'features/$folderName/presentation/cubit/${restClient.name.toSnake}_cubit.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.cubitClientFileContent(
        restClient,
        restClient.name.toPascal,
      ),
    );
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  GeneratedFile fillStateClientContent(UniversalRestClient restClient) {
    final folderName = restClient.name.toSnake;
    return  GeneratedFile(
      name: 'features/$folderName/presentation/cubit/${restClient.name.toSnake}_state.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.stateClientFileContent(
        restClient,
        restClient.name.toPascal,
      ),
    );
  }


  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  GeneratedFile fillRepositoryImplClientContent(UniversalRestClient restClient) {
    final fileName = _programmingLanguage == ProgrammingLanguage.dart
        ? '${restClient.name}_repository_impl'.toSnake
        : restClient.name.toPascal + _clientPostfix.toPascal;
    final folderName = restClient.name.toSnake;
    return GeneratedFile(
      name: 'features/$folderName/data/repository/$fileName.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.repositoryImplClientFileContent(
        restClient,
        restClient.name.toPascal,
      ),
    );
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  List<GeneratedFile> fillTestDataSourcesClientContent(UniversalRestClient restClient) {

    final folderName = restClient.name.toSnake;
    return restClient.requests.map((request) => GeneratedFile(
      name: 'tests/$folderName/data/remote/datasource/${restClient.name.toSnake}_remote_data_source_impl/${request.name.toSnake}.test.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.dataTestSourceClientFileContent(
        restClient,
        request,
      ),
    ),).toList();
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  List<GeneratedFile> fillTestRepositoryClientContent(UniversalRestClient restClient) {

    final folderName = restClient.name.toSnake;
    return restClient.requests.map((request) => GeneratedFile(
      name: 'tests/$folderName/data/repository/${restClient.name.toSnake}_repository_impl/${request.name.toSnake}.test.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.dataTestRepositoryFileContent(
        restClient,
        request,
      ),
    ),).toList();
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  List<GeneratedFile> fillTestUseCasesClientContent(UniversalRestClient restClient) {

    final folderName = restClient.name.toSnake;
    return restClient.requests.map((request) => GeneratedFile(
      name: 'tests/$folderName/domain/${request.name.toSnake}.test.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.dataTestUseCasesClientFileContent(
        restClient,
        request,
      ),
    ),).toList();
  }

  /// Return [GeneratedFile] generated from given [UniversalRestClient]
  List<GeneratedFile> fillTestCubitClientContent(UniversalRestClient restClient) {

    final folderName = restClient.name.toSnake;
    return restClient.requests.map((request) => GeneratedFile(
      name: 'tests/$folderName/presentation/cubit/${restClient.name.toSnake}_cubit/${request.name.toSnake}.test.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.dataCubitClientFileContent(
        restClient,
        request,
      ),
    ),).toList();
  }




  GeneratedFile fillRootInterface(Iterable<UniversalRestClient> clients) {
    final clientsNames = clients.map((c) => c.name.toPascal).toSet();
    return GeneratedFile(
      name: 'rest_client.${_programmingLanguage.fileExtension}',
      contents: _programmingLanguage.rootInterfaceFileContent(
        clientsNames,
        postfix: _clientPostfix.toPascal,
        squishClients: _squishClients,
      ),
    );
  }
}
