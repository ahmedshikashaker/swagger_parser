import 'dart:developer' show log;

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/json.dart';
import 'package:swagger_parser/swagger_parser.dart';
import 'package:swagger_parser_pages/components/code_editor_widget.dart';
import 'package:swagger_parser_pages/utils/chatgpt_api.dart';
import 'package:swagger_parser_pages/utils/file_utils.dart';

class GeneratorContent extends StatefulWidget {
  const GeneratorContent({super.key});

  @override
  State<GeneratorContent> createState() => _GeneratorContentState();
}

class _GeneratorContentState extends State<GeneratorContent> {
  final CodeController swaggerController = CodeController(language: json);
  final ProgrammingLanguage _language = ProgrammingLanguage.dart;
  bool _isYaml = false;
  bool _freezed = false;
  final bool _rootInterface = true;
  final bool _squishClients = false;

  @override
  Widget build(BuildContext context) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    runSpacing: 20,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CodeEditorWidget(
          title: 'Paste your Swagger Link , OpenApi JSON or YAML file content in the textarea below, '
              'click "Generate and download" and get your generated files in zip archive.',
          codeController: swaggerController,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setState) => CheckboxListTile(
                  title: const Text('Is YAML file content'),
                  value: _isYaml,
                  onChanged: (value) => setState(() => _isYaml = value!),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 600),
                crossFadeState: _language == ProgrammingLanguage.dart
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                sizeCurve: Curves.fastOutSlowIn,
                // for correct animation
                firstChild: Container(),
                secondChild: StatefulBuilder(
                  builder: (context, setState) => CheckboxListTile(
                    title: const Text('Use freezed for models'),
                    value: _freezed,
                    onChanged: (value) =>
                        setState(() => _freezed = value!),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                child: OutlinedButton(
                  child: const Text(
                    'Generate and download',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () async {
                    await _generateOutputs(
                      context,
                      schema: swaggerController.text,
                      clientPostfix: '',
                      language: _language,
                      freezed: _freezed,
                      squishClients: _squishClients,
                      isYaml: _isYaml,
                      rootInterface: _rootInterface,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

Future<void> _generateOutputs(
  BuildContext context, {
  required String schema,
  required String clientPostfix,
  required ProgrammingLanguage language,
  required bool freezed,
  required bool squishClients,
  required bool isYaml,
  required bool rootInterface,
}) async {
  var content= schema;
  if(isURL(schema)) {
    content = await getSwaggerJson(schema);
  }

  final generator = Generator.fromString(
    schemaContent: content,
    language: language,
    clientPostfix: clientPostfix.trim().isEmpty ? null : clientPostfix,
    freezed: freezed,
    squishClients: squishClients,
    isYaml: isYaml,
    rootInterface: rootInterface,
  );
  try {
    final files = await generator.generateContent();
    generateArchive(files);
  } on Object catch (e) {
    log(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
