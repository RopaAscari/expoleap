import 'package:expoleap/widgets/no_results.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/widgets/error.dart';
import 'package:expoleap/models/speaker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/widgets/search_bar.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/widgets/event_menu.dart';
import 'package:expoleap/widgets/placeholder.dart';
import 'package:expoleap/cubit/speaker_cubit.dart';
import 'package:expoleap/widgets/user_intials.dart';
import 'package:expoleap/widgets/flash_message.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/models/event_cubit_bundle.dart';
import 'package:expoleap/ui/speaker/speaker_screen.dart';
import 'package:expoleap/state/speaker/speaker_state.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

class SpeakerListScreen extends StatefulWidget {
  final EventModel event;
  final EventCubitBundle cubitBundle;

  SpeakerListScreen({required this.event, required this.cubitBundle});

  SpeakerListScreenState createState() => SpeakerListScreenState();
}

class SpeakerListScreenState extends State<SpeakerListScreen> {
  bool isFocused = false;
  List<Speaker> speakersClone = [];
  final SpeakerCubit speakerCubit = new SpeakerCubit();
  final TextEditingController searchController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    fetchSpeakers();
    super.initState();
  }

  void fetchSpeakers() {
    speakerCubit.fetchSpeakers(eventId: widget.event.id);
  }

  void searchSpeakers(List<Speaker> speakers, String term) {
    speakerCubit.searchSpeakers(speakers: speakers, term: term);
  }

  Widget build(BuildContext context) {
    final Color baseColor = BlocProvider.of<ThemeCubit>(context)
                .state
                .maybeWhen(
                    data: (theme) => theme,
                    orElse: () => Constants.of(context).darkTheme) ==
            Constants.of(context).darkTheme
        ? Colors.white
        : Colors.black;

    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            drawer: new Drawer(
              child: EventMenu(
                event: widget.event,
                route: EventRoutes.Speaker,
                cubitBundle: widget.cubitBundle,
              ),
            ),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                appBar(
                  baseColor,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: BlocConsumer<SpeakerCubit, SpeakerState>(
                            builder:
                                (BuildContext context, SpeakerState state) {
                              return state.when(
                                  idle: () => Center(),
                                  loading: () => PlaceHolder(count: 10),
                                  data: (speakers) => Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: speakerListView(speakers)),
                                  error: (error) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.70,
                                      child: Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            ErrorDisplay(
                                                error: error,
                                                enableRefresh: true,
                                                onRefresh: () =>
                                                    fetchSpeakers())
                                          ])));
                            },
                            listener:
                                (BuildContext context, SpeakerState state) {
                              final error = state.maybeWhen(
                                  error: (error) => error, orElse: () => null);

                              if (speakersClone.length == 0) {
                                final List<Speaker> data = state.maybeWhen(
                                    data: (data) => data, orElse: () => []);

                                this.setState(() => speakersClone = data);
                              }

                              if (error != null) {
                                return FlashMessage.snackBuilder(
                                    context, error, SnackBarType.Error);
                              }
                            },
                            bloc: speakerCubit,
                          ))
                    ],
                  ),
                ),
              ],
            )));
  }

  SliverAppBar appBar(Color baseColor) {
    return SliverAppBar(
      elevation: 0,
      floating: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: baseColor,
              )),
          Text('Speakers',
              style: TextStyle(
                  color: baseColor,
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                  fontWeight: FontWeight.w400)),
          Center()
        ],
      ),
      automaticallyImplyLeading: false,
      //  title: null,
      backgroundColor: Colors.transparent,
    );
  }

  Widget speakerListView(List<Speaker> speakers) {
    if (speakers.length == 0 && !isFocused) {
      return Center(
          child: Text('No speakers available for this event',
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.4))));
    }
    return Column(children: [
      FocusScope(
          child: Focus(
              onFocusChange: (focus) {
                this.setState(() => isFocused = focus);
              },
              child: SearchBar(
                controller: searchController,
                onClear: () => fetchSpeakers(),
                onSearch: (e) => searchSpeakers(speakersClone, e),
              ))),
      ConditionalRenderDelegate(
          condition: speakers.length == 0 && isFocused,
          renderWidget: NoResults(),
          fallbackWidget: Center()),
      listView(speakers)
    ]);
  }

  Widget listView(List<Speaker> speakers) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: speakers.length,
        itemBuilder: (BuildContext context, int index) {
          final avatar = speakers[index].avatar;
          final title = speakers[index].jobTitle ?? '';
          final String name =
              '${speakers[index].name.first} ${speakers[index].name.last}';

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
                  fallbackWidget: UserInitials(name: speakers[index].name)),
              title: Text(name,
                  style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.5))),
              subtitle: Text(
                title,
                style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context).fontSize(1.3)),
              ),
              onTap: () => NavigationCubit.navigatorInstance.navigateTo(
                  route: SpeakerScreen(speaker: speakers[index]),
                  context: context));
        });
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
                        borderRadius: BorderRadius.circular(10))),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                    width: 150,
                    height: 8.0,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
