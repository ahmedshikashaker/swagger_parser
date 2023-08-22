import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/dart.dart';
import 'package:swagger_parser/swagger_parser.dart';

class APIGeneratorOutputScreen extends StatefulWidget {
  const APIGeneratorOutputScreen({super.key, this.apiGeneratorOutput});

  final ApiGeneratorOutput? apiGeneratorOutput;

  @override
  State<APIGeneratorOutputScreen> createState() =>
      _APIGeneratorOutputScreenState();
}

class _APIGeneratorOutputScreenState extends State<APIGeneratorOutputScreen> {
  CodeController modelsController = CodeController(language: dart);
  CodeController requestModelController = CodeController(language: dart);
  CodeController serviceController = CodeController(language: dart);
  CodeController dataSourceController = CodeController(language: dart);
  CodeController dataSourceImplController = CodeController(language: dart);
  CodeController repositoryController = CodeController(language: dart);
  CodeController repositoryImplController = CodeController(language: dart);
  CodeController useCaseController = CodeController(language: dart);

  @override
  void initState() {
    if (widget.apiGeneratorOutput != null) {
      serviceController.text = widget.apiGeneratorOutput?.serviceCode ?? '';
      dataSourceController.text =
          widget.apiGeneratorOutput?.dataSourceCode ?? '';
      dataSourceImplController.text =
          widget.apiGeneratorOutput?.dataSourceImplCode ?? '';
      repositoryController.text =
          widget.apiGeneratorOutput?.repositoryCode ?? '';
      repositoryImplController.text =
          widget.apiGeneratorOutput?.repositoryImplCode ?? '';
      modelsController.text = widget.apiGeneratorOutput?.modelCode ?? '';

      requestModelController.text =
          widget.apiGeneratorOutput?.requestCode ?? '';

      useCaseController.text = widget.apiGeneratorOutput?.useCaseCode ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.apiGeneratorOutput != null
        ? Column(
            children: [
              CodeViewerWidget(
                codeController: modelsController,
                title: 'Response Models',
              ),
              CodeViewerWidget(
                codeController: requestModelController,
                title: 'Request Models',
              ),
              CodeViewerWidget(
                codeController: serviceController,
                title: 'Service',
              ),
              CodeViewerWidget(
                codeController: dataSourceController,
                title: 'DataSource',
              ),
              CodeViewerWidget(
                codeController: dataSourceImplController,
                title: 'DataSourceImplementation',
              ),
              CodeViewerWidget(
                codeController: repositoryController,
                title: 'Repository',
              ),
              CodeViewerWidget(
                codeController: repositoryImplController,
                title: 'RepositoryImplementation',
              ),
              CodeViewerWidget(
                codeController: useCaseController,
                title: 'UseCase',
              ),
            ],
          )
        : Container();
  }
}

class CodeViewerWidget extends StatelessWidget {
  const CodeViewerWidget({
    required this.codeController,
    required this.title,
    super.key,
  });

  final CodeController codeController;
  final String title;

  @override
  Widget build(BuildContext context) {
    return codeController.text.isNotEmpty
        ? Container(
            margin: const EdgeInsets.all(20),
            color: Colors.black.withOpacity(0.4),
            child: CodeTheme(
              data: const CodeThemeData(styles: monokaiSublimeTheme),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    title,
                    style:
                        Theme.of(context).typography.englishLike.headlineLarge,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CodeField(
                    controller: codeController,
                    textStyle: const TextStyle(fontFamily: 'SourceCode'),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
