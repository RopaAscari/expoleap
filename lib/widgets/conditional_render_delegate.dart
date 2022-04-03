import 'package:flutter/material.dart';

class ConditionalRenderDelegate extends StatefulWidget {
  final bool condition;
  final Widget renderWidget;
  final Widget fallbackWidget;
  ConditionalRenderDelegate(
      {required this.condition,
      required this.renderWidget,
      required this.fallbackWidget});
  ConditionalRenderDelegateState createState() =>
      ConditionalRenderDelegateState();
}

class ConditionalRenderDelegateState extends State<ConditionalRenderDelegate> {
  Widget build(BuildContext _) {
    if (widget.condition) {
      return widget.renderWidget;
    }
    return widget.fallbackWidget;
  }
}
