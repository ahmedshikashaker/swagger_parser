import 'package:flutter/material.dart';
import 'package:swagger_parser_pages/router/app_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter router = AppRouter();

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Development kit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFD0BCFF),
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.light,
        routerDelegate: router.delegate(),
        routeInformationParser: router.defaultRouteParser(),
        routeInformationProvider: router.routeInfoProvider(),
      );
}
