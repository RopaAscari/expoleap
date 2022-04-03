import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/themes/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class ChangeThemeScreen extends StatefulWidget {
  ChangeThemeScreen({Key? key});
  ChangeThemeScreenState createState() => ChangeThemeScreenState();
}

class ChangeThemeScreenState extends State<ChangeThemeScreen> {
  String currentTheme = '';
  @override
  initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        currentTheme = BlocProvider.of<ThemeCubit>(context).state.maybeWhen(
            data: (theme) => theme,
            orElse: () => Constants.of(context).darkTheme);
      });
    });
    super.initState();
  }

  Widget build(BuildContext ccontext) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      headerWidget(),
      Container(
        height: 200,
        margin: const EdgeInsets.only(top: 200),
        child: Flex(direction: Axis.horizontal, children: [themeListWidget()]),
      ),
    ])));
  }

  _onThemeChange(String theme) {
    setState(() {
      currentTheme = theme;
    });
    BlocProvider.of<ThemeCubit>(context).changeTheme(theme: theme);
  }

  Widget headerWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: ResponsiveFlutter.of(context).fontSize(1.8)),
          onPressed: () =>
              NavigationCubit.navigatorInstance.pop(context: context)),
      Text(
        'Change Theme',
        style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.5)),
      ),
      Center()
    ]);
  }

  Widget themeListWidget() {
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: AppTheme.values.length,
      itemBuilder: (context, index) {
        final itemAppTheme = AppTheme.values[index];
        final theme = itemAppTheme == AppTheme.Dark
            ? Constants.of(context).darkTheme
            : Constants.of(context).lightTheme;
        return Card(
          margin: const EdgeInsets.only(top: 15),
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: new BorderSide(
                  color: currentTheme == theme
                      ? Colors.amber[800]!
                      : Colors.transparent,
                  width: 1.5)),
          color: appThemeData[itemAppTheme]?.canvasColor,
          child: ListTile(
            title: Text(
              theme,
              style: appThemeData[itemAppTheme]?.textTheme.bodyText2,
            ),
            onTap: () {
              _onThemeChange(theme);
            },
          ),
        );
      },
    ));
  }
}
