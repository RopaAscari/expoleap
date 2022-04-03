import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/state/navigation/navigation_state.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(Idle());

  static final NavigationCubit navigatorInstance = NavigationCubit();

  void navigateTo(
      {required Widget route,
      required BuildContext context,
      shouldPreserveRouteHistory = true,
      PageTransitionType transition = PageTransitionType.slideInLeft}) {
    try {
      if (Platform.isIOS) {
        Navigator.pushAndRemoveUntil(context,
            CupertinoPageRoute<dynamic>(builder: (BuildContext context) {
          return route;
        }), (route) => shouldPreserveRouteHistory);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder<dynamic>(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return route;
                },
                transitionDuration: const Duration(milliseconds: 250),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return effectMap[transition](
                      Curves.linear, animation, secondaryAnimation, child);
                }),
            (route) => shouldPreserveRouteHistory);
      }
    } catch (e) {}
  }

  void pop({required BuildContext context}) {
    Navigator.pop(context);
  }
}
