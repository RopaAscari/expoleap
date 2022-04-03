import 'package:expoleap/widgets/no_results.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/widgets/error.dart';
import 'package:expoleap/ui/event_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/event_cubit.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/widgets/refresher.dart';
import 'package:expoleap/ui/settings_screen.dart';
import 'package:expoleap/widgets/event_tile.dart';
import 'package:expoleap/widgets/placeholder.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/state/event/event_state.dart';
import 'package:expoleap/cubit/notification_cubit.dart';
import 'package:expoleap/cubit/pinned_event_cubit.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/state/pinned_event/pinned_event_state.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart'
    as transition;
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class HomeScreen extends StatefulWidget {
  final EventCubit eventCubit;
  final bool enableHeroAniamtion;
  final PinnedEventCubit pinnedEventCubit;
  final NotificationCubit notificationCubit;

  HomeScreen({
    Key? key,
    required this.eventCubit,
    required this.pinnedEventCubit,
    required this.notificationCubit,
    required this.enableHeroAniamtion,
  }) : super(key: key);

  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;
  bool showCloseIcon = false;
  List<dynamic> events = [];
  bool shouldRenderUI = false;
  bool isPinnedShowing = true;
  GlobalKey key = GlobalKey();
  bool isFetchingEvent = false;
  bool isOpeningPinned = false;
  final Key linkKey = GlobalKey();
  EventCubit get eventCubit => widget.eventCubit;
  PinnedEventCubit get pinnedEventCubit => widget.pinnedEventCubit;
  TextEditingController searchController = new TextEditingController();

  @override
  initState() {
    if (!widget.enableHeroAniamtion) {
      this.setState(() => shouldRenderUI = true);
    }
    super.initState();
    fetchPinnedEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  cancelSearch() {
    this.setState(() {
      isSearching = false;
    });
    searchController.clear();
    FocusScope.of(context).unfocus();
  }

  initiateSearch() {
    this.setState(() {
      isSearching = true;
    });
  }

  fetchPinnedEvents() {
    pinnedEventCubit.fetchPinnedEvents();
  }

  navigateToSettingsScreen() {
    /*final route = EventScreen(
        cubit: new PinnedEventCubit(),
        tag: '',
        notificationCubit: widget.notificationCubit,
        event: Constants.of(context).placeHolderEvent);*/
    NavigationCubit.navigatorInstance
        .navigateTo(route: SettingsScreen(), context: context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverToBoxAdapter(
            child: SafeArea(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Scaffold(
                        backgroundColor: Theme.of(context).canvasColor,
                        resizeToAvoidBottomInset: false,
                        body: ConditionalRenderDelegate(
                            condition: shouldRenderUI,
                            renderWidget: Column(children: [
                              ConditionalRenderDelegate(
                                  condition: isOpeningPinned,
                                  renderWidget: Center(),
                                  fallbackWidget: headerWidget(isDarkTheme)),
                              ConditionalRenderDelegate(
                                  condition: isSearching,
                                  renderWidget: Center(),
                                  fallbackWidget:
                                      pinnedEventContainerWidget(isDarkTheme)),
                            ]),
                            fallbackWidget: Container(
                                margin: const EdgeInsets.only(top: 50),
                                height: MediaQuery.of(context).size.height,
                                child: appLogo(isDarkTheme)))))))
      ],
    );
  }

  Widget searchResults(bool isDarkTheme) {
    return SizedBox.expand(
        child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              BlocBuilder<EventCubit, EventState>(
                  bloc: eventCubit,
                  builder: (BuildContext context, EventState state) {
                    return state.when(
                      idle: () => searchDefaultWidget(),
                      loading: () => searchLoadingWidget(isDarkTheme),
                      error: (String error) => ErrorDisplay(
                          error: error,
                          enableRefresh: true,
                          onRefresh: () => null),
                      data: (List<EventModel> data) {
                        if (data.length == 0) {
                          return NoResults();
                        }
                        return searchedResuts(data);
                      },
                    );
                  })
            ])));
  }

  Widget pinnedEventShimmer(bool isDarkTheme) {
    final height = 600.0;
    final width = 150.0;
    return Container(
        margin: const EdgeInsets.only(top: 65),
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: AnimationLimiter(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: 4,
                    itemBuilder: (BuildContext _, int index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: Shimmer.fromColors(
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      width: width,
                                      margin: const EdgeInsets.only(top: 10),
                                      height: height,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )),
                                period: Duration(milliseconds: 1500),
                                baseColor: HexColor(
                                    isDarkTheme ? '#4E4D4D' : '#EEECEC'),
                                highlightColor: isDarkTheme
                                    ? Colors.grey[700]!
                                    : Colors.grey[200]!,
                                enabled: true,
                              ))));
                    }))));
  }

  Widget searchDefaultWidget() {
    return Expanded(
        child: Center(
            child: Container(
                margin: const EdgeInsets.only(bottom: 200),
                child: Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      Constants.of(context).search,
                      scale: 0.6,
                    )))));
  }

  Widget searchErrorWidget(String error) {
    return Expanded(
        child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        '$error  ',
        style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.5)),
      ),
      Image.asset(Constants.of(context).errorIcon, height: 20, width: 20),
    ])));
  }

  Widget emptySearchResults() {
    return Expanded(
        child: Center(
      child: //Row(children: [
          Text(
        'No results found  ',
        style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.5)),
      ),
    ));
  }

  Widget searchedResuts(List<EventModel> searchEvents) {
    return Expanded(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (_, index) => EventTile(
                  event: searchEvents[index],
                  cubit: widget.pinnedEventCubit,
                  notificationCubit: widget.notificationCubit,
                ),
            itemCount: searchEvents.length));
  }

  Widget searchLoadingWidget(bool isDarkTheme) {
    return Expanded(child: PlaceHolder(count: 10));
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

  Widget emptyPinnedEvents() {
    return Container(
        height: 600,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            Constants.of(context).pinLogo,
          ),
          Text('\nYou have no pinned events',
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.2)))
        ])));
  }

  Widget pinnedEventGridWidget(List<dynamic> pinnedEvents, bool isDarkTheme) {
    if (pinnedEvents.length == 0) {
      return emptyPinnedEvents();
    }

    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(15),
          child: ConditionalRenderDelegate(
            condition: isOpeningPinned,
            renderWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: ResponsiveFlutter.of(context).fontSize(1.7),
                    ),
                    onPressed: () async {
                      this.setState(() {
                        isOpeningPinned = false;
                        isPinnedShowing = false;
                      });
                      await Future.delayed(Duration(milliseconds: 150));
                      this.setState(() {
                        isPinnedShowing = true;
                      });
                    },
                  ),
                  Text('Pinned Events',
                      style: TextStyle(
                          //  fontWeight: FontWeight.bold,
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.5))),
                ]),
            fallbackWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pinned Events',
                      style: TextStyle(
                          fontSize:
                              ResponsiveFlutter.of(context).fontSize(1.56))),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: ResponsiveFlutter.of(context).fontSize(1.7),
                    ),
                    onPressed: () async {
                      this.setState(() {
                        isOpeningPinned = true;
                        isPinnedShowing = false;
                      });

                      await Future.delayed(Duration(milliseconds: 150));
                      this.setState(() {
                        isPinnedShowing = true;
                      });
                    },
                  )
                ]),
          )),
      ConditionalRenderDelegate(
          condition: isPinnedShowing,
          renderWidget: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SizedBox(
                  height: isOpeningPinned
                      ? MediaQuery.of(context).size.height - 150
                      : 600,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: AnimationLimiter(
                          child: Refresher(
                              onRefresh: () => fetchPinnedEvents(),
                              showIndicator: true,
                              child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: pinnedEvents.length >= 4 &&
                                          !isOpeningPinned
                                      ? 4
                                      : pinnedEvents.length,
                                  itemBuilder: (BuildContext _, int index) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                                child: pinnedEvent(
                                                    index,
                                                    pinnedEvents,
                                                    isDarkTheme))));
                                  })))))),
          fallbackWidget: Center())
    ]);
  }

  Widget pinnedEventContainerWidget(bool isDarkTheme) {
    return Expanded(
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[800]!,
                    offset: Offset(1.0, 1.0), //(x,y)
                    blurRadius: 2.0,
                  ),
                ],
                color: HexColor(
                  isDarkTheme ? '#1D1D1D' : '#F7F7F7',
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35))),
            child: Stack(children: <Widget>[
              LayoutBuilder(builder: (_, c) {
                return CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      CupertinoSliverRefreshControl(
                        refreshTriggerPullDistance: 100.0,
                        refreshIndicatorExtent: 60.0,
                        onRefresh: () async {
                          await Future.delayed(Duration(milliseconds: 600));
                          fetchPinnedEvents();
                        },
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            BlocBuilder<PinnedEventCubit, PinnedEventState>(
                                bloc: pinnedEventCubit,
                                builder: (BuildContext context,
                                    PinnedEventState state) {
                                  return state.when(
                                      idle: () => Center(),
                                      loading: () =>
                                          pinnedEventShimmer(isDarkTheme),
                                      error: (error) => Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 700,
                                          child: Flex(
                                              direction: Axis.vertical,
                                              children: [
                                                ErrorDisplay(
                                                  error: error,
                                                  enableRefresh: true,
                                                  onRefresh: () =>
                                                      fetchPinnedEvents(),
                                                )
                                              ])),
                                      data: (pinnedEvents) =>
                                          pinnedEventGridWidget(
                                              pinnedEvents, isDarkTheme));
                                })
                          ],
                        ),
                      )
                    ]);
              })
            ])));
  }

  Widget pinnedEvent(int index, pinnedEvents, bool isDarkTheme) {
    final double height = MediaQuery.of(context).size.height * 0.20;
    final double width = MediaQuery.of(context).size.width * 0.40;
    final DateTime start = DateTime.parse(pinnedEvents[index].dates[0].start);
    final DateTime end = DateTime.parse(pinnedEvents[index].dates[0].end);

    final String startString = DateFormat('MMM d, y').format(start);
    final String endString = DateFormat('MMM d, y').format(end);

    return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
            onTap: () => NavigationCubit.navigatorInstance.navigateTo(
                route: EventScreen(
                  event: pinnedEvents[index],
                  tag: pinnedEvents[index].id,
                  cubit: widget.pinnedEventCubit,
                  notificationCubit: widget.notificationCubit,
                ),
                context: context),
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDarkTheme ? Colors.grey[900] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(children: [
                  Hero(
                      tag: pinnedEvents[index].id,
                      child: ConditionalRenderDelegate(
                          condition: pinnedEvents[index].logo != null,
                          renderWidget: Container(
                              height: height,
                              width: width,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          pinnedEvents[index].logo)))),
                          fallbackWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                Constants.of(context).defaultEvent,
                                width: 150,
                              )))),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(pinnedEvents[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                              fontSize: ResponsiveFlutter.of(context)
                                  .fontSize(1.3)))),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      child: Text('\n$startString - $endString',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[600]
                                  : Colors.grey[700],
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.1))))
                ]))));
  }

  Widget headerText() {
    return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          'What events are you looking for?',
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: ResponsiveFlutter.of(context).fontSize(1.25)),
        ));
  }

  Widget appLogo(bool isDarkTheme) {
    final Widget logoWidget = Align(
        alignment: Alignment.topCenter,
        child: Image.asset(
          isDarkTheme
              ? Constants.of(context).appLogoDark
              : Constants.of(context).appLogoLight,
          height: 60,
          width: 180,
        ));

    return Hero(
        flightShuttleBuilder: (_, animation, __, ___, ____) {
          animation.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              this.setState(() {
                shouldRenderUI = true;
              });
            }
          });
          return logoWidget;
        },
        tag: Constants.of(context).appLogoHeroTag,
        child: logoWidget);
  }

  Widget searchContainerWidget(bool isDarkTheme) {
    return AnimatedContainer(
        key: key,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        width: isSearching
            ? MediaQuery.of(context).size.width * 0.80
            : MediaQuery.of(context).size.width * 0.90,
        child: TextField(
            onTap: () => initiateSearch(),
            onChanged: (e) {
              if (e != '' && !showCloseIcon) {
                this.setState(() => showCloseIcon = true);
                eventCubit.searchEvents(term: e);
              } else if (e == '') {
                this.setState(() => showCloseIcon = false);
              }
            },
            controller: searchController,
            decoration: new InputDecoration(
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
                suffixIcon: showCloseIcon
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          this.setState(() => showCloseIcon = false);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: HexColor(isDarkTheme ? '#ECEAEA' : '#4E4D4E'),
                        ))
                    : Icon(
                        Icons.search,
                        color: HexColor(isDarkTheme ? '#ECEAEA' : '#4E4D4E'),
                      ),
                fillColor: HexColor(isDarkTheme ? '#ECEAEA' : '#696868')
                    .withOpacity(0.06),
                filled: true,
                labelText: 'Search Events',
                contentPadding: const EdgeInsets.only(top: 10.0, left: 10.0))));
  }

  Widget headerWidget(bool isDarkTheme) {
    return SizedBox(
        height: isSearching ? MediaQuery.of(context).size.height : 200,
        child: Stack(alignment: Alignment.center, children: [
          Container(
              margin: const EdgeInsets.only(top: 70),
              child: isSearching ? searchResults(isDarkTheme) : Center()),
          AnimatedPositioned(
              top: isSearching ? -103 : 0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                        opacity: 0.9,
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 1.2,
                                top: 25),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () => navigateToSettingsScreen(),
                                icon: Icon(
                                  Icons.settings,
                                  size: 23,
                                  // textDirection: TextDirection.RTL,
                                )))),
                    appLogo(isDarkTheme),
                    Row(children: [
                      searchContainerWidget(isDarkTheme),
                      ConditionalRenderDelegate(
                          condition: isSearching,
                          renderWidget: InkWell(
                              child: Text(
                                '   Cancel',
                                style: TextStyle(
                                    color: Colors.blue[500],
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.4)),
                              ),
                              onTap: () => cancelSearch()),
                          fallbackWidget: Center())
                    ]),
                    ConditionalRenderDelegate(
                        condition: isSearching,
                        renderWidget: Center(),
                        fallbackWidget: headerText())
                  ]),
              duration: Duration(milliseconds: 200)),
        ]));
  }
}
