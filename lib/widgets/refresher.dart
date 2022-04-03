import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:expoleap/widgets/conditional_render_delegate.dart';

class Refresher extends StatefulWidget {
  final Widget child;
  final bool showIndicator;
  final VoidCallback onRefresh;
  Refresher(
      {required this.child,
      required this.onRefresh,
      required this.showIndicator});

  RefresherState createState() => RefresherState();
}

class RefresherState extends State<Refresher> {
  RefreshController _smartRefreshController = new RefreshController();

  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(
          idleText: '',
          releaseText: '',
          completeText: '',
          refreshingText: '',
          idleIcon: renderIcon(),
          completeIcon: renderIcon(),
          releaseIcon: renderIcon(),
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            return Center();
          },
        ),
        controller: _smartRefreshController,
        onRefresh: () {
          widget.onRefresh();
          _smartRefreshController.refreshCompleted();
        },
        onLoading: () => null,
        child: widget.child);
  }

  Widget renderIcon() {
    return ConditionalRenderDelegate(
        condition: widget.showIndicator,
        renderWidget: CupertinoActivityIndicator(),
        fallbackWidget: Center());
  }
}
