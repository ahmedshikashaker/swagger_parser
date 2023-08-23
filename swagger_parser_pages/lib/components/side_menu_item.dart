import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatefulWidget {

  const SideMenuItem(
      {required this.itemText, required this.onItemClicked, super.key,
      this.itemSelectedBackground,
      this.itemId,});
  final Color? itemSelectedBackground;
  final String itemText;
  final dynamic itemId;
  final Function onItemClicked;

  @override
  State<SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem> {
  @override
  Widget build(BuildContext context) {
    final appThemeData = Theme.of(context);

    final itemColor = () {
      if (isCurrentItemSelected) {
        return Colors.lightGreenAccent.shade700;
      }else{
        return Colors.lightGreenAccent.withOpacity(.1);
      }
    }();

    final itemTextColor = () {
      return Colors.white;
    }();


    final itemTextWidget = () {
      if (isCurrentItemSelected) {
        return Text(
          widget.itemText,
          style: TextStyle(color: itemTextColor),
        );
      } else {
        return Text(
          widget.itemText,
          style: TextStyle(color: itemTextColor),
        );
      }
    }();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          widget.onItemClicked(widget.itemId);
        },
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: itemColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),),
          child: Row(
            children: [
              const SizedBox(height: 16,),
              itemTextWidget,
            ],
          ),
        ),
      ),
    );
  }

  bool get isCurrentItemSelected => context.router.currentUrl
      .contains((widget.itemId as PageRouteInfo).fullPath);
}
