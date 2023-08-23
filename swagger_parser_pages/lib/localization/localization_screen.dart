import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/json.dart';
import 'package:swagger_parser/swagger_parser.dart';
import 'package:swagger_parser_pages/components/code_editor_widget.dart';
import 'package:swagger_parser_pages/utils/file_utils.dart';

class LocalizationScreen extends StatefulWidget {
  const LocalizationScreen({super.key});

  @override
  State<LocalizationScreen> createState() => _LocalizationScreenState();
}

class _LocalizationScreenState extends State<LocalizationScreen> {
  final CodeController _localizationJsonController = CodeController(
    language: json,
  );
  final CodeController _resultController = CodeController(
    language: dart,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            CodeEditorWidget(
                title: 'Enter Localization Json',
                codeController: _localizationJsonController),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 40,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  final localizationData =
                      LocalizationGenerator(_localizationJsonController.text)
                          .generateLocalizationVariables();
                  _resultController.text = localizationData;

                  generateLocalizationArchive(localizationData , 'localization_generated');

                },
                child: const Text('Generate'),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            CodeEditorWidget(
                title: 'Localization Generation Result',
                codeController: _resultController,),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
