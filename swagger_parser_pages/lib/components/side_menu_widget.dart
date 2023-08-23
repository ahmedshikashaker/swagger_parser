import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:swagger_parser_pages/components/side_menu_item.dart';
import 'package:swagger_parser_pages/router/app_router.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: .5,
      shape: const Border(right: BorderSide(color: Colors.grey)),
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 48),
        color: Colors.teal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 36,
                      ),
                      const SizedBox(
                          height:150 ,
                          child: RiveAnimation.asset('assets/5103-10277-handshake.riv' , fit: BoxFit.fitWidth,)),
                      const SizedBox(height: 16,),
                      SideMenuItem(
                        itemText: 'Swagger Generation',
                        itemId: const SwaggerRouter(),
                        itemSelectedBackground: Colors.amberAccent,
                        onItemClicked: (destination) {
                          context.navigateTo(destination as SwaggerRouter);
                          setState(() {});
                        },
                      ),
                      SideMenuItem(
                        itemText: 'Localization Generation ',
                        itemId: const LocalizationRouter(),
                        itemSelectedBackground: Colors.amberAccent,
                        onItemClicked: (destination) {
                          context.navigateTo(destination as LocalizationRouter);
                          setState(() {});
                        },
                      ),
                      SideMenuItem(
                        itemText: 'Module/Feature Generation ',
                        itemId: const ModuleFeatureRouter(),
                        itemSelectedBackground: Colors.amberAccent,
                        onItemClicked: (destination) {
                          context
                              .navigateTo(destination as ModuleFeatureRouter);
                          setState(() {});
                        },
                      ),
                      SideMenuItem(
                        itemText: 'API Generation',
                        itemId: const ApiGenRouter(),
                        itemSelectedBackground: Colors.amberAccent,
                        onItemClicked: (destination) {
                          context.navigateTo(destination as ApiGenRouter);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
