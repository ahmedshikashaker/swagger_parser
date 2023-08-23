// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    SwaggerRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RouterWrapperScreen(),
      );
    },
    LocalizationRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RouterWrapperScreen(),
      );
    },
    ModuleFeatureRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RouterWrapperScreen(),
      );
    },
    ApiGenRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RouterWrapperScreen(),
      );
    },
    SwaggerRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SwaggerScreen(),
      );
    },
    LocalizationRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LocalizationScreen(),
      );
    },
    ModuleCreationRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ModuleCreationScreen(),
      );
    },
    APICreatorRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const APICreatorScreen(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          HomeRoute.name,
          path: '/',
          children: [
            RouteConfig(
              '#redirect',
              path: '',
              parent: HomeRoute.name,
              redirectTo: 'swagger_gen',
              fullMatch: true,
            ),
            RouteConfig(
              SwaggerRouter.name,
              path: 'swagger_gen',
              parent: HomeRoute.name,
              children: [
                RouteConfig(
                  SwaggerRoute.name,
                  path: '',
                  parent: SwaggerRouter.name,
                )
              ],
            ),
            RouteConfig(
              LocalizationRouter.name,
              path: 'localization_gen',
              parent: HomeRoute.name,
              children: [
                RouteConfig(
                  LocalizationRoute.name,
                  path: '',
                  parent: LocalizationRouter.name,
                )
              ],
            ),
            RouteConfig(
              ModuleFeatureRouter.name,
              path: 'module_feature_gen',
              parent: HomeRoute.name,
              children: [
                RouteConfig(
                  ModuleCreationRoute.name,
                  path: '',
                  parent: ModuleFeatureRouter.name,
                )
              ],
            ),
            RouteConfig(
              ApiGenRouter.name,
              path: 'api_gen',
              parent: HomeRoute.name,
              children: [
                RouteConfig(
                  APICreatorRoute.name,
                  path: '',
                  parent: ApiGenRouter.name,
                )
              ],
            ),
          ],
        )
      ];
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [RouterWrapperScreen]
class SwaggerRouter extends PageRouteInfo<void> {
  const SwaggerRouter({List<PageRouteInfo>? children})
      : super(
          SwaggerRouter.name,
          path: 'swagger_gen',
          initialChildren: children,
        );

  static const String name = 'SwaggerRouter';
}

/// generated route for
/// [RouterWrapperScreen]
class LocalizationRouter extends PageRouteInfo<void> {
  const LocalizationRouter({List<PageRouteInfo>? children})
      : super(
          LocalizationRouter.name,
          path: 'localization_gen',
          initialChildren: children,
        );

  static const String name = 'LocalizationRouter';
}

/// generated route for
/// [RouterWrapperScreen]
class ModuleFeatureRouter extends PageRouteInfo<void> {
  const ModuleFeatureRouter({List<PageRouteInfo>? children})
      : super(
          ModuleFeatureRouter.name,
          path: 'module_feature_gen',
          initialChildren: children,
        );

  static const String name = 'ModuleFeatureRouter';
}

/// generated route for
/// [RouterWrapperScreen]
class ApiGenRouter extends PageRouteInfo<void> {
  const ApiGenRouter({List<PageRouteInfo>? children})
      : super(
          ApiGenRouter.name,
          path: 'api_gen',
          initialChildren: children,
        );

  static const String name = 'ApiGenRouter';
}

/// generated route for
/// [SwaggerScreen]
class SwaggerRoute extends PageRouteInfo<void> {
  const SwaggerRoute()
      : super(
          SwaggerRoute.name,
          path: '',
        );

  static const String name = 'SwaggerRoute';
}

/// generated route for
/// [LocalizationScreen]
class LocalizationRoute extends PageRouteInfo<void> {
  const LocalizationRoute()
      : super(
          LocalizationRoute.name,
          path: '',
        );

  static const String name = 'LocalizationRoute';
}

/// generated route for
/// [ModuleCreationScreen]
class ModuleCreationRoute extends PageRouteInfo<void> {
  const ModuleCreationRoute()
      : super(
          ModuleCreationRoute.name,
          path: '',
        );

  static const String name = 'ModuleCreationRoute';
}

/// generated route for
/// [APICreatorScreen]
class APICreatorRoute extends PageRouteInfo<void> {
  const APICreatorRoute()
      : super(
          APICreatorRoute.name,
          path: '',
        );

  static const String name = 'APICreatorRoute';
}
