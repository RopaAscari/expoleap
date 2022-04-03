import 'package:flutter/material.dart';
import 'package:expoleap/models/name.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class UserInitials extends StatelessWidget {
  final Name name;
  const UserInitials({required this.name});

  @override
  Widget build(BuildContext context) {
    final String initals = name.first[0] + name.last[0];
    return Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.circular(100)),
        child: Text(initals,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                fontWeight: FontWeight.bold)));
  }
}
