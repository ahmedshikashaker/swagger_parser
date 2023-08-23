import 'package:flutter/material.dart';
import 'package:swagger_parser_pages/content/generator_content.dart';
import 'package:swagger_parser_pages/content/information_box.dart';

class SwaggerScreen extends StatelessWidget {
  const SwaggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            GeneratorContent(),
            SizedBox(height: 24),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
