
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class RouterWrapperScreen extends StatelessWidget {
  const RouterWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AutoRouter(), //,
    );
  }
}