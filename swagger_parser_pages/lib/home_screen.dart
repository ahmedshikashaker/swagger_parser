import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swagger_parser_pages/components/side_menu_widget.dart';
import 'package:swagger_parser_pages/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      physics: const NeverScrollableScrollPhysics(),
      routes: const [
        SwaggerRouter(),
        LocalizationRouter(),
        ModuleFeatureRouter(),
        ApiGenRouter()
      ],
      builder: (context, child, _) {
        return Scaffold(
          body: Row(
            children: [
              const SizedBox(
                width: 289,
                child: ClipRRect(
                    borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(24), bottomEnd: Radius.circular(24)),
                    child: SideMenuWidget()),
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}
