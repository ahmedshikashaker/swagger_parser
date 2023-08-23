import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swagger_parser_pages/api/api_creator_screen.dart';
import 'package:swagger_parser_pages/content/swagger_screen.dart';
import 'package:swagger_parser_pages/home_screen.dart';
import 'package:swagger_parser_pages/localization/localization_screen.dart';
import 'package:swagger_parser_pages/module/module_creation_screen.dart';
import 'package:swagger_parser_pages/router_wrapper_screen.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: HomeScreen,
      path:'/',
      children: [
        AutoRoute(
          page: RouterWrapperScreen,
          path: 'swagger_gen',
          name: 'SwaggerRouter',
          initial: true,
          children: [
            AutoRoute(
              path: '',
              page: SwaggerScreen,
            )
          ]
        ),
        AutoRoute(
            page: RouterWrapperScreen,
            path: 'localization_gen',
            name: 'LocalizationRouter',
            children: [
              AutoRoute(
                path: '',
                page: LocalizationScreen,
              )
            ]
        ),
        AutoRoute(
            page: RouterWrapperScreen,
            path: 'module_feature_gen',
            name: 'ModuleFeatureRouter',
            children: [
              AutoRoute(
                path: '',
                page: ModuleCreationScreen,
              )
            ]
        ),
        AutoRoute(
            page: RouterWrapperScreen,
            path: 'api_gen',
            name: 'ApiGenRouter',
            children: [
              AutoRoute(
                path: '',
                page: APICreatorScreen,
              )
            ]
        )
      ]
    ),

  ],
)
class AppRouter extends _$AppRouter {
}
