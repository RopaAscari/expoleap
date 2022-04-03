import 'package:expoleap/widgets/no_results.dart';
import 'package:expoleap/widgets/search_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expoleap/enums/enums.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/models/event.dart';
import 'package:expoleap/widgets/error.dart';
import 'package:expoleap/models/exhibitor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/cubit/theme_cubit.dart';
import 'package:expoleap/widgets/event_menu.dart';
import 'package:expoleap/widgets/placeholder.dart';
import 'package:expoleap/constants/constants.dart';
import 'package:expoleap/widgets/flash_message.dart';
import 'package:expoleap/cubit/exhibitor_cubit.dart';
import 'package:expoleap/cubit/navigation_cubit.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:expoleap/models/event_cubit_bundle.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:expoleap/ui/exhibitor/exhibitor_screen.dart';
import 'package:expoleap/state/exhibitor/exhibitor_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

class ExhibitorListScreen extends StatefulWidget {
  final EventModel event;
  final EventCubitBundle cubitBundle;
  ExhibitorListScreen({required this.event, required this.cubitBundle});

  ExhibitorListScreenState createState() => ExhibitorListScreenState();
}

class ExhibitorListScreenState extends State<ExhibitorListScreen> {
  bool isFocused = false;
  List<Exhibitor> exhibitorsClone = [];
  ExhibitorCubit exhibitorCubit = new ExhibitorCubit();
  final TextEditingController searchController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    fetchExhibitors();
    super.initState();
  }

  void fetchExhibitors() {
    exhibitorCubit.fetchExhibitors(eventId: widget.event.id);
  }

  void searchExhibitors(dynamic exhibitors, String term) {
    exhibitorCubit.searchExhibitors(exhibitors: exhibitors, term: term);
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
                  route: EventRoutes.Exhibitor),
            ),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                appBar(baseColor),
                exhibitorSliverList(baseColor)
              ],
            )));
  }

  SliverList exhibitorSliverList(Color baseColor) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
              padding: const EdgeInsets.all(15),
              child: BlocConsumer<ExhibitorCubit, ExhibitorState>(
                builder: (BuildContext context, ExhibitorState state) {
                  return state.when(
                      idle: () => Center(),
                      loading: () => PlaceHolder(count: 10),
                      data: (exhibitors) => Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: groupListView(exhibitors)),
                      error: (error) => Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.80,
                          child: Flex(direction: Axis.vertical, children: [
                            ErrorDisplay(
                                error: error,
                                enableRefresh: true,
                                onRefresh: () => fetchExhibitors())
                          ])));
                },
                listener: (BuildContext context, ExhibitorState state) {
                  if (exhibitorsClone.length == 0) {
                    List<Exhibitor> exhibitors = [];
                    final Map<String, List<Exhibitor>> data =
                        state.maybeWhen(data: (data) => data, orElse: () => {});

                    data.values.toList().forEach((exhibitor) {
                      exhibitors = [...exhibitors, ...exhibitor];
                    });

                    this.setState(() => exhibitorsClone = exhibitors);
                  }

                  final error = state.maybeWhen(
                      error: (error) => error, orElse: () => null);

                  if (error != null) {
                    return FlashMessage.snackBuilder(
                        context, error, SnackBarType.Error);
                  }
                },
                bloc: exhibitorCubit,
              ))
        ],
      ),
    );
  }

  SliverAppBar appBar(Color baseColor) {
    return SliverAppBar(
      floating: true,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: baseColor,
              )),
          Text('Exhibitors',
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

  Widget groupListView(Map<String, List<Exhibitor>> exhibitors) {
    final bool isDarkTheme = BlocProvider.of<ThemeCubit>(context)
            .state
            .maybeWhen(
                data: (theme) => theme,
                orElse: () => Constants.of(context).darkTheme) ==
        Constants.of(context).darkTheme;

    if (exhibitors.keys.toList().length == 0 && !isFocused) {
      return Center(
          child: Text('No exhibitors available for this event',
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
                onClear: () => fetchExhibitors(),
                onSearch: (e) => searchExhibitors(exhibitorsClone, e),
              ))),
      ConditionalRenderDelegate(
          condition: exhibitors.length == 0 && isFocused,
          renderWidget: NoResults(),
          fallbackWidget: Center()),
      Expanded(child: listView(exhibitors, isDarkTheme))
    ]);
  }

  Widget listView(Map<String, List<Exhibitor>> exhibitors, bool isDarkTheme) {
    return GroupListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      sectionsCount: exhibitors.keys.toList().length,
      countOfItemInSection: (int section) {
        return exhibitors.values.toList()[section].length;
      },
      itemBuilder: (BuildContext context, IndexPath index) {
        final name =
            exhibitors.values.toList()[index.section][index.index].name;
        final logo =
            exhibitors.values.toList()[index.section][index.index].logo;
        final label =
            exhibitors.values.toList()[index.section][index.index].label ?? '';
        return ListTile(
            leading: ConditionalRenderDelegate(
                condition: logo != null,
                renderWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                        width: 67.0,
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
                route: ExhibitorScreen(
                    exhibitor: exhibitors.values.toList()[index.section]
                        [index.index]),
                context: context));
      },
      groupHeaderBuilder: (BuildContext context, int section) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            exhibitors.keys.toList()[section],
            style: TextStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(1.65),
                fontWeight: FontWeight.w600),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10),
      sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
    );
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
