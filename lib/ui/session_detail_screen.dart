import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:expoleap/models/name.dart';
import 'package:expoleap/models/session.dart';
import 'package:expoleap/models/speaker.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:expoleap/widgets/user_intials.dart';
import 'package:expoleap/models/session_speaker.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/ui/speaker/speaker_screen.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:expoleap/resources/repositories/speaker_repository.dart';

class SessionDetailScreen extends StatefulWidget {
  final Session session;
  SessionDetailScreen({Key? key, required this.session}) : super(key: key);

  SessionDetailScreenState createState() => SessionDetailScreenState();
}

class SessionDetailScreenState extends State<SessionDetailScreen> {
  Session get session => widget.session;
  @override
  Widget build(BuildContext _) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;
    final String title = session.title;
    final String start = DateFormat.jm().format(DateTime.parse(session.start));
    final String end =
        DateFormat.jm().format(DateTime.parse(session.end ?? (session.start)));

    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: ResponsiveFlutter.of(context).fontSize(1.7),
                      ),
                      onPressed: () => NavigationCubit.navigatorInstance
                          .pop(context: context)),
                  Center(),
                  Icon(
                    Entypo.back_in_time,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  )
                ]),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).canvasColor,
          ),
          SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                Text(title,
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.0))),
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(' $start - $end',
                        style: TextStyle(
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.1)))),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 0.8,
                    color: Colors.grey[800]),
                speakerList()
              ])))
        ])));
  }

  Widget speakerList() {
    if (session.participants?.length == 0) {
      return Center();
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('\n\n\nSpeakers',
              style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.6))),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: session.participants?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final id = session.participants?[index].name.id ?? 0;
                    final avatar = session.participants?[index].avatar;
                    final title = session.participants?[index].title ?? '';
                    final String name =
                        '${session.participants?[index].name.first} ${session.participants?[index].name.last}';

                    return ListTile(
                        leading: ConditionalRenderDelegate(
                            condition: avatar != null,
                            renderWidget: Container(
                                width: 50.0,
                                height: 50.0,
                                //  margin: const EdgeInsets.only(top: 20),
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            avatar as String)))),
                            fallbackWidget: UserInitials(
                                name:
                                    session.participants?[index].name as Name)),
                        title: Text(name,
                            style: TextStyle(
                                fontSize: ResponsiveFlutter.of(context)
                                    .fontSize(1.5))),
                        subtitle: Text(
                          title,
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.3)),
                        ),
                        onTap: () async {
                          final Speaker speaker =
                              await SpeakerRepository().fetchSpeaker(id);
                          NavigationCubit.navigatorInstance.navigateTo(
                              route: SpeakerScreen(speaker: speaker),
                              context: context);
                        });
                  }))
        ]);
  }
}
