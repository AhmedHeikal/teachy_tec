import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teachy_tec/widgets/RemoveScrollSplash.dart';

class AppPullToRefreshComponent extends StatefulWidget {
  AppPullToRefreshComponent(
      {required this.onRefresh,
      this.onRefreshCompleted,
      this.onRefreshStarted,
      this.physics,
      required this.child,
      this.scrollController,
      Key? key})
      : super(key: key);
  final ScrollPhysics? physics;
  final Future<void> Function()? onRefresh;
  final Widget child;
  final VoidCallback? onRefreshCompleted;
  final VoidCallback? onRefreshStarted;
  final ScrollController? scrollController;

  @override
  State<AppPullToRefreshComponent> createState() =>
      _AppPullToRefreshComponentState();
}

class _AppPullToRefreshComponentState extends State<AppPullToRefreshComponent> {
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    refreshController = RefreshController();
  }

  @override
  void dispose() {
    refreshController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('Heikal - tomato pull to refresh build');
    // debugPrint('Heikal - tomato pull to refresh controller state ' +
    //refreshController.isTwoLevel.toString());
    return ScrollConfiguration(
      behavior: RemoveScrollSplash(),
      child: SmartRefresher(
        physics: widget.physics,
        // dragStartBehavior: DragStartBehavior.down,
        // enablePullUp: true,
        controller: refreshController,
        scrollController: widget.scrollController,
        // physics: NeverScrollableScrollPhysics(),
        // onTwoLevel: (isOpen) {
        //   // debugPrint('Heikal - tomato pull to refresh is two levels ' +
        //       refreshController.isTwoLevel.toString());
        // },
        enablePullDown: widget.onRefresh != null,
        onRefresh: widget.onRefresh != null
            ? () async {
                if (widget.onRefreshStarted != null) {
                  widget.onRefreshStarted!();
                }
                await widget.onRefresh!();

                refreshController.refreshCompleted();
                if (widget.onRefreshCompleted != null) {
                  widget.onRefreshCompleted!();
                }
                return;
              }
            : null,
        child: widget.child,
      ),
    );
  }
}
