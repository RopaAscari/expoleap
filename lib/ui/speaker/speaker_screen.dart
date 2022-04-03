import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/models/session.dart';
import 'package:expoleap/resources/repositories/session_repository.dart';
import 'package:expoleap/ui/session_detail_screen.dart';
import 'package:expoleap/widgets/read_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/models/social.dart';
import 'package:expoleap/models/speaker.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:intl/intl.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/models/contact.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/widgets/image_screen.dart';
import 'package:expoleap/widgets/contact_details.dart';
import 'package:expoleap/widgets/social_media_links.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class SpeakerScreen extends StatelessWidget {
  final Speaker speaker;
  SpeakerScreen({required this.speaker});

  Widget build(BuildContext context) {
    final bio = speaker.bio ?? '';
    final avatar = speaker.avatar;
    final Social social = speaker.social;

    final sessions = speaker.sessions;

    final String name = '${speaker.name.first} ${speaker.name.last}';

    final Contact contact =
        new Contact(email: speaker.email, phone: speaker.phone, website: null);

    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(data: (theme) => theme, orElse: () => 'Dark') ==
        Constants.of(context).darkTheme;
    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            title: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                    ),
                    onPressed: () => NavigationCubit.navigatorInstance
                        .pop(context: context)),
                Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.4)),
                    )),
                Center()
              ])
            ]),
            automaticallyImplyLeading: false,
            backgroundColor: isDarkTheme ? Colors.black : HexColor('#F8F8F8'),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.only(bottom: 25),
              //  height: 450,
              decoration: BoxDecoration(
                  color: isDarkTheme ? Colors.black : HexColor('#F8F8F8'),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Center(
                child: Column(children: [
                  ConditionalRenderDelegate(
                      condition: avatar != null,
                      renderWidget: Hero(
                          tag: Constants.of(context).appImageHeroTag,
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () => NavigationCubit.navigatorInstance
                                      .navigateTo(
                                          route: ImageScreen(
                                              imageFile: avatar as String),
                                          context: context),
                                  child: Container(
                                      width: 150.0,
                                      height: 150.0,
                                      margin: const EdgeInsets.only(top: 20),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                  avatar as String))))))),
                      fallbackWidget: Image.asset(
                        Constants.of(context).defaultEvent,
                        width: 150.0,
                        height: 150.0,
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.all(20),
                      child: ReadMoreText(bio,
                          // overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: ResponsiveFlutter.of(context)
                                  .fontSize(1.35))))
                ]),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: sessionListWidget(sessions ?? [], context, isDarkTheme)),
            contactDetailWidget(contact),
            socialMediaLinksWidget(social)
          ])),
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
                    color: HexColor('#232323').withOpacity(0.7)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: ResponsiveFlutter.of(context).fontSize(1.65),
                  ),
                ))));
  }

  Widget sessionListWidget(List<Session> sessions, context, isDarkTheme) {
    if (sessions.length == 0) {
      return Center();
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('\n\n\Sessions',
              style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.8))),
          Container(
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sessions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final id = sessions[index].id;
                    final title = sessions[index].title;
                    final String start = DateFormat.jm()
                        .format(DateTime.parse(sessions[index].start));
                    final String end = DateFormat.jm().format(DateTime.parse(
                        sessions[index].end ?? (sessions[index].start)));

                    return Card(
                        color: isDarkTheme
                            ? HexColor('#282626')
                            : HexColor('#F8F8F8'),
                        child: ListTile(
                            trailing: Icon(
                              Entypo.back_in_time,
                              size: 22,
                            ),
                            title: Text(title,
                                style: TextStyle(
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.55))),
                            subtitle: Text(
                              ' $start - $end',
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.15)),
                            ),
                            onTap: () async {
                              /* final Session session =
                                  await SessionRepository().fetchSession(id);
                              Navigator.push(
                                  context,
                                  PageRouteBuilder<dynamic>(
                                      //     settings: routeSettings,
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return SessionDetailScreen(
                                            session: session);
                                      },
                                      transitionDuration:
                                          const Duration(milliseconds: 150),
                                      transitionsBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secondaryAnimation,
                                          Widget child) {
                                        return effectMap[
                                                PageTransitionType.slideInLeft](
                                            Curves.linear,
                                            animation,
                                            secondaryAnimation,
                                            child);
                                      }));*/
                            }));
                  }))
        ]);
  }

  Widget socialMediaLinksWidget(Social social) {
    return SocialMediaLinks(socials: social);
  }

  Widget contactDetailWidget(Contact contact) {
    return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: ContactDetails(
          contact: contact,
        ));
  }
}
