import 'package:flutter/material.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/utils/utils.dart';

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: HexColor('#F5F5F5'),
    canvasColor: HexColor('#FFFFFF'),
    fontFamily: 'Inter',
    buttonColor: HexColor('#13111A'),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: HexColor('#504E51')),
      bodyText2: TextStyle(color: HexColor('#E4E3E3')),
    ).apply(
      bodyColor: HexColor('#504E51'),
      displayColor: HexColor('#262527'),
    ),
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    buttonColor: Colors.white,
    canvasColor: HexColor('#151515'),
    primaryColor: HexColor('#1D1D1D'),
    fontFamily: 'Inter',
    textTheme: TextTheme(
      bodyText1: TextStyle(color: HexColor('#DCDBDB')),
      bodyText2: TextStyle(color: HexColor('#262527')),
    ).apply(bodyColor: HexColor('#E4E3E3'), displayColor: HexColor('#E4E3E3')),
  ),
};
