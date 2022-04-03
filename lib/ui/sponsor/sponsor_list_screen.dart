import 'package:expoleap/widgets/no_results.dart';
import 'package:expoleap/widgets/search_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/widgets/error.dart';
import 'package:expoleap/models/sponsor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/widgets/event_menu.dart';
import 'package:expoleap/widgets/placeholder.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/cubit/sponspor_cubit.dart';
import 'package:expoleap/widgets/flash_message.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:expoleap/models/event_cubit_bundle.dart';
import 'package:expoleap/ui/sponsor/sponsor_screen.dart';
import 'package:expoleap/state/sponsor/sponsor_state.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class SponsorListScreen extends StatefulWidget {
  final EventModel event;
  final EventCubitBundle cubitBundle;
  SponsorListScreen({required this.event, required this.cubitBundle});

  SponsorListScreenState createState() => SponsorListScreenState();
}

class SponsorListScreenState extends State<SponsorListScreen> {
  bool isFocused = false;
  List<Sponsor> sponsorsClone = [];
  SponsorCubit sponsorCubit = new SponsorCubit();
  final TextEditingController searchController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState() {
    fetchSponsors();
    super.initState();
  }

  void fetchSponsors() {
    sponsorCubit.fetchSponsors(eventId: widget.event.id);
  }

  void searchSponsors(List<Sponsor> sponsors, String term) {
    sponsorCubit.searchSponsors(sponsors: sponsors, term: term);
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
                  cubitBundle: widget.cubitBundle,
                  route: EventRoutes.Sponsor),
            ),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                appBar(baseColor),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: BlocConsumer<SponsorCubit, SponsorState>(
                            builder:
                                (BuildContext context, SponsorState state) {
                              return state.when(
                                  idle: () => Center(),
                                  loading: () => PlaceHolder(count: 10),
                                  data: (exhibitors) => Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: groupListView(exhibitors)),
                                  error: (error) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.80,
                                      child: Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            ErrorDisplay(
                                                error: error,
                                                enableRefresh: true,
                                                onRefresh: () =>
                                                    fetchSponsors())
                                          ])));
                            },
                            listener:
                                (BuildContext context, SponsorState state) {
                              if (sponsorsClone.length == 0) {
                                List<Sponsor> sponsors = [];
                                final Map<String, List<Sponsor>> data =
                                    state.maybeWhen(
                                        data: (data) => data, orElse: () => {});

                                data.values.toList().forEach((sponsor) {
                                  sponsors = [...sponsors, ...sponsor];
                                });

                                this.setState(() => sponsorsClone = sponsors);
                              }

                              final error = state.maybeWhen(
                                  error: (error) => error, orElse: () => null);

                              if (error != null) {
                                return FlashMessage.snackBuilder(
                                    context, error, SnackBarType.Error);
                              }
                            },
                            bloc: sponsorCubit,
                          ))
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget groupListView(Map<String, List<Sponsor>> sponsors) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;

    if (sponsors.keys.toList().length == 0 &&
        !isFocused &&
        searchController.text == '') {
      return Center(
          child: Text('No sponsors available for this event',
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
                onClear: () => fetchSponsors(),
                onSearch: (e) => searchSponsors(sponsorsClone, e),
              ))),
      ConditionalRenderDelegate(
          condition: sponsors.length == 0 && isFocused,
          renderWidget: NoResults(),
          fallbackWidget: Center()),
      Expanded(child: listView(sponsors, isDarkTheme))
    ]);
  }

  Widget listView(Map<String, List<Sponsor>> sponsors, bool isDarkTheme) {
    return GroupListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      sectionsCount: sponsors.keys.toList().length,
      countOfItemInSection: (int section) {
        return sponsors.values.toList()[section].length;
      },
      itemBuilder: (BuildContext context, IndexPath index) {
        final name = sponsors.values.toList()[index.section][index.index].name;
        final logo = sponsors.values.toList()[index.section][index.index].logo;
        final label =
            sponsors.values.toList()[index.section][index.index].label ?? '';
        return ListTile(
            leading: ConditionalRenderDelegate(
                condition: logo != null,
                renderWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                        width: 68.0,
                        height: 50.0,
                        //  margin: const EdgeInsets.only(top: 20),
                        decoration: new BoxDecoration(
                            color: isDarkTheme
                                ? Colors.black
                                : HexColor('#F8F8F8'),
                            image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: CachedNetworkImageProvider(
                                    logo as String))))),
                fallbackWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      Constants.of(context).defaultEvent,
                      width: 50.0,
                      height: 50.0,
                    ))),
            title: Text(
              name,
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.5)),
            ),
            subtitle: Text(
              label,
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.3)),
            ),
            onTap: () => NavigationCubit.navigatorInstance.navigateTo(
                route: SponsorScreen(
                    sponsor: sponsors.values.toList()[index.section]
                        [index.index]),
                context: context));
      },
      groupHeaderBuilder: (BuildContext context, int section) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            sponsors.keys.toList()[section],
            style: TextStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(1.65),
                fontWeight: FontWeight.w600),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10),
      sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
    );
    ;
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
          Text('Sponsors',
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
}
