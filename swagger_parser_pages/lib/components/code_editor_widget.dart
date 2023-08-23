import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class CodeEditorWidget extends StatelessWidget {
  const CodeEditorWidget({required this.title, required this.codeController, super.key});
  final String title;
  final CodeController codeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title , style: Theme.of(context).typography.englishLike.headlineMedium,),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.4),
                child: CodeTheme(
                  data: const CodeThemeData(styles: monokaiSublimeTheme),
                  child: CodeField(
                    controller: codeController,
                    textStyle: const TextStyle(fontFamily: 'SourceCode'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
