import 'package:expoleap/widgets/conditional_render_delegate.dart';
import 'package:flutter/material.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class SearchBar extends StatefulWidget {
  final VoidCallback onClear;
  final ValueSetter<String> onSearch;
  final TextEditingController controller;

  SearchBar(
      {required this.onClear,
      required this.onSearch,
      required this.controller});
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  Widget build(BuildContext context) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;
    return Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
        child: SizedBox(
            height: 38,
            child: TextField(
                onChanged: (e) => widget.onSearch(e),
                controller: widget.controller,
                decoration: new InputDecoration(
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.3)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: new OutlineInputBorder(
                      // borderSide: new BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: HexColor(isDarkTheme ? '#ECEAEA' : '#4E4D4E'),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          widget.onClear();
                          widget.controller.clear();
                          //   this.setState(() => showCloseIcon = false);
                        },
                        icon: ConditionalRenderDelegate(
                            condition: false, // widget.controller.text != '',
                            renderWidget: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color:
                                  HexColor(isDarkTheme ? '#ECEAEA' : '#4E4D4E'),
                            ),
                            fallbackWidget: Center())),
                    fillColor: HexColor(isDarkTheme ? '#ECEAEA' : '#696868')
                        .withOpacity(0.06),
                    filled: true,
                    labelText: 'Search',
                    contentPadding:
                        const EdgeInsets.only(top: 10.0, left: 10.0)))));
  }
}
