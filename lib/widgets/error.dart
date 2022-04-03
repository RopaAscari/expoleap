import 'package:flutter/material.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class ErrorDisplay extends StatelessWidget {
  final String error;
  final bool? enableRefresh;
  final VoidCallback? onRefresh;
  ErrorDisplay({
    this.onRefresh,
    this.enableRefresh,
    required this.error,
  });

  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          '$error  ',
          style:
              TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.25)),
        ),
        Image.asset(Constants.of(context).errorIcon, height: 20, width: 20),
      ]),
      ConditionalRenderDelegate(
          condition: enableRefresh != null && enableRefresh == true,
          renderWidget: InkWell(
              onTap: () => onRefresh!(),
              child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Theme.of(context).textTheme.bodyText1!.color
                              as Color)),
                  child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Text('Try Again',
                          style: TextStyle(
                              fontSize: ResponsiveFlutter.of(context)
                                  .fontSize(1.1)))))),
          fallbackWidget: Center())
    ])));
  }
}
