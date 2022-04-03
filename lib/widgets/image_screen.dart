import 'package:flutter/material.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  final String imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        body: GestureDetector(
            onPanUpdate: (details) {
              // Swiping in up direction.
              if (details.delta.dy > 0) {
                print('Swiping in up direction');
              }

              // Swiping in down direction.
              if (details.delta.dy < 0) {
                print('Swiping in down direction.');
              }
            },
            child: Center(
                child: Material(
                    color: Colors.transparent,
                    child: Hero(
                        tag: Constants.of(context).appImageHeroTag,
                        child: InteractiveViewer(
                            child: Container(
                                width: 500.0,
                                height: 500.0,
                                margin: const EdgeInsets.only(top: 0),
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        fit: BoxFit.contain,
                                        image: CachedNetworkImageProvider(
                                            imageFile))))))))));
  }
}
