import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/ui/change_theme_screen.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  SettingsScreenScreenState createState() => SettingsScreenScreenState();
}

class SettingsScreenScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext _) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      appBarWidget(),
      settingsListWidget(),
    ])));
  }

  Widget appBarWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: ResponsiveFlutter.of(context).fontSize(1.7)),
          onPressed: () =>
              NavigationCubit.navigatorInstance.pop(context: context)),
      Text(
        'Settings',
        style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.5)),
      ),
      Center()
    ]);
  }

  Widget settingsListWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(children: [
          ListTile(
              trailing: Icon(CupertinoIcons.color_filter),
              title: Text('Theme',
                  style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.5))),
              onTap: () {
                NavigationCubit.navigatorInstance
                    .navigateTo(context: context, route: ChangeThemeScreen());
              }),
          ListTile(
              trailing: Icon(CupertinoIcons.bell),
              title: Text('Notifications',
                  style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.5))),
              onTap: () {})
        ]));
  }
}
