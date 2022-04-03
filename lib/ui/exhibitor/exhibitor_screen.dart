import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/widgets/read_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/models/social.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/models/contact.dart';
import 'package:expoleap/models/exhibitor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/widgets/image_screen.dart';
import 'package:expoleap/widgets/contact_details.dart';
import 'package:expoleap/widgets/social_media_links.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class ExhibitorScreen extends StatelessWidget {
  final Exhibitor exhibitor;
  ExhibitorScreen({required this.exhibitor});

  Widget build(BuildContext context) {
    final name = exhibitor.name;
    final logo = exhibitor.logo;
    final description = exhibitor.description ?? '';
    final Social social = exhibitor.social;
    final Contact contact = new Contact(
        email: exhibitor.email, phone: exhibitor.phone, website: null);

    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;

    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            title: null,
            leading: backIconWidget(context),
            expandedHeight: 400.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: eventLogo(logo, context),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: isDarkTheme ? Colors.black : HexColor('#F8F8F8'),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                //height: MediaQuery.of(context).size.height,
                child: Column(children: [
              Container(
                padding: const EdgeInsets.only(bottom: 25),
                //  height: 450,
                decoration: BoxDecoration(
                    color: isDarkTheme ? Colors.black : HexColor('#F8F8F8'),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(name,
                                    style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.3))))),
                        Container(
                            padding: const EdgeInsets.all(10),
                            child: ReadMoreText(description,
                                style: TextStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.3))))
                      ]),
                ),
              ),
              contactDetailWidget(contact),
              socialMediaLinksWidget(social)
            ]))
          ]))
        ])));
  }

  Widget backIconWidget(BuildContext context) {
    return GestureDetector(
        onTap: () => NavigationCubit.navigatorInstance.pop(context: context),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: HexColor('#232323').withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: ResponsiveFlutter.of(context).fontSize(1.65),
                  ),
                ))));
  }

  Widget eventLogo(String? logo, BuildContext context) {
    return ConditionalRenderDelegate(
        condition: logo != null,
        renderWidget: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0)),
                image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: CachedNetworkImageProvider(logo as String)))),
        fallbackWidget: ClipRRect(
            child: Image.asset(
              Constants.of(context).defaultEvent,
              width: MediaQuery.of(context).size.width,
              height: 400,
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(0))));
  }

  Widget socialMediaLinksWidget(Social socials) {
    return SocialMediaLinks(socials: socials);
  }

  Widget contactDetailWidget(Contact contact) {
    return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: ContactDetails(
          contact: contact,
        ));
  }
}
