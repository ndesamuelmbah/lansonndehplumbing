import 'package:lansonndehplumbing/custom/custom_widget.dart';
import 'package:lansonndehplumbing/custom/size_config.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar({
  required String title,
  Widget? titleWidget,
  List<Widget> actions = const [],
  double? elevation,
  PreferredSizeWidget? bottom,
  bool? centerTitle,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    title: Builder(
      builder: (context) {
        return Text(
          title,
          maxLines: 2,
          style: CustomWidget(context).commonTextStyles(FontWeight.bold,
              Colors.black, SizeConfig.blockSizeVertical! * 2.3),
        );
      },
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.elliptical(16, 16),
      ),
    ),
    actions: actions,
    elevation: elevation ?? 0,
    centerTitle: centerTitle,
    bottom: bottom,
  );
}
