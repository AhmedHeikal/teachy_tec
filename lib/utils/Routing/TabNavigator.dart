import 'package:flutter/cupertino.dart';
import 'package:teachy_tec/screens/Dashboard/DashboardMainScreen.dart';
import 'package:teachy_tec/screens/Dashboard/DashboardMainScreenVM.dart';
import 'package:teachy_tec/screens/HomeScreen.dart';
import 'package:teachy_tec/screens/HomeScreenVM.dart';
import 'package:teachy_tec/screens/SettingsScreen.dart';
import 'package:teachy_tec/screens/SettingsScreenVM.dart';
import 'package:teachy_tec/utils/Routing/PageRoutes.dart';
import 'package:teachy_tec/utils/Routing/TabItem.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
    required this.showBottomNav,
    super.key,
  });

  final void Function(bool) showBottomNav;
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  String rootName() {
    switch (tabItem) {
      case TabItem.home:
        return AppAnalyticsConstants.homeScreen;
      case TabItem.activity:
        return AppAnalyticsConstants.activityScreen;
      case TabItem.settings:
        return AppAnalyticsConstants.settingsScreen;
    }
  }

  Map<String, WidgetBuilder> _routeBuilders(
    BuildContext context, {
    required Map<String, dynamic> arguments,
  }) {
    // var provider = Provider.of<TomatoScaffoldVM>(context, listen: false);
    return {
      rootName(): (context) {
        if (tabItem == TabItem.home) {
          return HomeScreen(
            key: UniqueKey(),
            model: HomeScreenVM(),
          );
        } else if (tabItem == TabItem.activity) {
          return DashboardMainScreen(
            key: UniqueKey(),
            model: DashboardMainScreenVM(),
          );
        } else if (tabItem == TabItem.settings) {
          return SettingsScreen(
            key: UniqueKey(),
            model: SettingsScreenVM(),
          );
        } else {
          return Container();
        }
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [
        _NavigatorHistory(showBottomNav: showBottomNav, tabItem: tabItem),
        // FirebaseAnalyticsObserver(analytics: AnalyticsService.analytics)
      ],
      key: navigatorKey,
      initialRoute: rootName(),
      onGenerateRoute: (routeSettings) {
        bool showNavigator = routeSettings.arguments == null
            ? true
            : ((routeSettings.arguments as Map<String, dynamic>)['PageDetails']
                    as PageDetails)
                .isBottomBarShown;

        final routeBuilders = _routeBuilders(context,
            arguments: routeSettings.arguments as Map<String, dynamic>? ?? {});

        return CupertinoPageRoute(
            builder: (context) {
              return routeBuilders[routeSettings.name]!(context);
            },
            settings: RouteSettings(
                name: routeSettings.name ??
                    (routeSettings.arguments == null
                        ? ''
                        : ((routeSettings.arguments
                                    as Map<String, dynamic>)['PageDetails']
                                as PageDetails)
                            .pageName),
                arguments: [showNavigator]));
      },
    );
  }
}

class _NavigatorHistory extends NavigatorObserver {
  _NavigatorHistory({required this.showBottomNav, required this.tabItem});
  final void Function(bool) showBottomNav;
  final TabItem tabItem;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Heikal - route changed');
    if (route.settings.arguments == null) {
      showBottomNav(false);
    } else {
      showBottomNav((route.settings.arguments as List).first as bool);
      if (route.settings.name != null) {
        debugPrint('Heikal - route settings name ${route.settings.name}');

        UIRouter.setCurrentScreenName(route.settings.name!, tabItem);
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    showBottomNav(
        ((previousRoute?.settings.arguments as List?)?.first as bool?) ??
            false);
    if (previousRoute?.settings.name != null) {
      debugPrint(
          'Heikal - route settings name ${previousRoute!.settings.name}');

      UIRouter.setCurrentScreenName(previousRoute.settings.name!, tabItem);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print(
        "${oldRoute?.settings.name} is replaced by ${newRoute?.settings.name}");
    if (newRoute?.settings.name != null) {
      debugPrint('Heikal - route settings name ${newRoute?.settings.name}');

      UIRouter.setCurrentScreenName(newRoute!.settings.name!, tabItem);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("${route.settings.name} removed");
    if (previousRoute?.settings.name != null) {
      debugPrint(
          'Heikal - route settings name ${previousRoute?.settings.name}');

      UIRouter.setCurrentScreenName(previousRoute!.settings.name!, tabItem);
    }
  }
}
