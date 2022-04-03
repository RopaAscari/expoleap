import 'package:flutter/material.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class NoResults extends StatelessWidget {
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Text('No results found',
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.4))),
          Image.asset(Constants.of(context).emptySearch, height: 45, width: 45)
        ])));
  }
}
