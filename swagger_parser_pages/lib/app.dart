import 'package:flutter/material.dart';
import 'package:swagger_parser_pages/api/api_creator_screen.dart';
import 'package:swagger_parser_pages/localization/localization_screen.dart';
import 'package:swagger_parser_pages/module/module_creation_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Swagger Parser',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFD0BCFF),
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.light,
        home: const ModuleCreationScreen(),
      );
}
