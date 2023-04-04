import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class IconLabel extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final double dist;
  const IconLabel(
      {super.key,
      required this.icon,
      required this.text,
      this.dist = 10});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [icon, SizedBox(width: dist), text],
    );
  }
}
