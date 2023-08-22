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
  CodeController serviceController = CodeController(language: dart);
  CodeController dataSourceController = CodeController(language: dart);
  CodeController repositoryController = CodeController(language: dart);
  CodeController modelsController = CodeController(language: dart);

  @override
  void initState() {
    if (widget.apiGeneratorOutput != null) {
      serviceController.text = '''
      ${widget.apiGeneratorOutput?.serviceCode}
      ''';
      dataSourceController.text = '''
      ${widget.apiGeneratorOutput?.dataSourceCode}
      ''';
      repositoryController.text = '''
      ${widget.apiGeneratorOutput?.repositoryCode}
      ''';
      modelsController.text = '''
      ${widget.apiGeneratorOutput?.modelCode}
      ''';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.apiGeneratorOutput != null
        ? Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.4),
                child: CodeTheme(
                  data: const CodeThemeData(styles: monokaiSublimeTheme),
                  child: CodeField(
                    controller: serviceController,
                    textStyle: const TextStyle(fontFamily: 'SourceCode'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.4),
                child: CodeTheme(
                  data: const CodeThemeData(styles: monokaiSublimeTheme),
                  child: CodeField(
                    controller: dataSourceController,
                    textStyle: const TextStyle(fontFamily: 'SourceCode'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.4),
                child: CodeTheme(
                  data: const CodeThemeData(styles: monokaiSublimeTheme),
                  child: CodeField(
                    controller: repositoryController,
                    textStyle: const TextStyle(fontFamily: 'SourceCode'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.4),
                child: CodeTheme(
                  data: const CodeThemeData(styles: monokaiSublimeTheme),
                  child: CodeField(
                    controller: modelsController,
                    textStyle: const TextStyle(fontFamily: 'SourceCode'),
                  ),
                ),
              ),

            ],
          )
        : Container();
  }
}
