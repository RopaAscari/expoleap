import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PlaceHolder extends StatelessWidget {
  final int count;
  PlaceHolder({required this.count});

  Widget build(BuildContext context) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Shimmer.fromColors(
          period: Duration(milliseconds: 1500),
          baseColor: HexColor(isDarkTheme ? '#4E4D4D' : '#EEECEC'),
          highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[200]!,
          enabled: true,
          child: ListView.builder(
              itemBuilder: (_, index) => placeHolderWidget(), itemCount: count),
        ));
  }

  Widget placeHolderWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 200,
                    height: 8.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1))),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                    width: 150,
                    height: 8.0,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
