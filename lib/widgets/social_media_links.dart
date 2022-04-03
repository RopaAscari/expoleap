import 'package:flutter/material.dart';
import 'package:expoleap/models/social.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class SocialMediaLinks extends StatelessWidget {
  final Social socials;
  SocialMediaLinks({required this.socials});

  @override
  Widget build(BuildContext context) {
    final isSocial = socials.twitter != '' ||
        socials.facebook != '' ||
        socials.instagram != '' ||
        socials.linkedin != '' ||
        socials.youtube != '';
    openSocialMediaLink(String link) async {
      if (await canLaunch(link))
        await launch(link);
      else
        await launch(link, forceWebView: true);
    }

    return ConditionalRenderDelegate(
        condition: !isSocial,
        renderWidget: Center(),
        fallbackWidget: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 35),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Social\n',
                      style: TextStyle(
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.8))),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ConditionalRenderDelegate(
                        condition: Uri.parse(socials.facebook).isAbsolute,
                        fallbackWidget: Center(),
                        renderWidget: Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: InkWell(
                                onTap: () =>
                                    openSocialMediaLink('${socials.facebook}'),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.asset(
                                      Constants.of(context).facebookIcon,
                                      height: 30,
                                      width: 30,
                                      scale: 0.8,
                                      // semanticsLabel: 'Acme ',
                                    )))),
                      ),
                      ConditionalRenderDelegate(
                          condition: Uri.parse(socials.instagram).isAbsolute,
                          fallbackWidget: Center(),
                          renderWidget: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: InkWell(
                                  onTap: () => openSocialMediaLink(
                                      '${socials.instagram}'),
                                  child: Image.asset(
                                    Constants.of(context).instgramIcon,
                                    height: 30,
                                    width: 30,
                                    scale: 0.8, // semanticsLabel: 'Acme ',
                                  )))),
                      ConditionalRenderDelegate(
                          condition: Uri.parse(socials.twitter).isAbsolute,
                          fallbackWidget: Center(),
                          renderWidget: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: InkWell(
                                  onTap: () =>
                                      openSocialMediaLink('${socials.twitter}'),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                        Constants.of(context).twitterIcon,
                                        height: 30,
                                        width: 30,
                                        scale: 0.8,
                                        // semanticsLabel: 'Acme ',
                                      ))))),
                      ConditionalRenderDelegate(
                          condition: Uri.parse(socials.linkedin).isAbsolute,
                          fallbackWidget: Center(),
                          renderWidget: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: InkWell(
                                  onTap: () => openSocialMediaLink(
                                      '${socials.linkedin}'),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.asset(
                                        Constants.of(context).linkedlnIcon,
                                        height: 30,
                                        width: 30,
                                        scale: 0.8,
                                        // semanticsLabel: 'Acme ',
                                      ))))),
                      ConditionalRenderDelegate(
                          condition: Uri.parse(socials.youtube).isAbsolute,
                          fallbackWidget: Center(),
                          renderWidget: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: InkWell(
                                  onTap: () =>
                                      openSocialMediaLink('${socials.youtube}'),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: Image.asset(
                                        Constants.of(context).youTubeIcon,
                                        height: 30,
                                        width: 30,
                                        scale: 1,
                                        // semanticsLabel: 'Acme ',
                                      )))))
                    ],
                  ))
                ])));
  }
}
