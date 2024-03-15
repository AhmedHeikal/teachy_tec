import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:teachy_tec/main.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/Routing/TabItem.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class UIRouterBottomNavigation with ChangeNotifier {
  bool isBottomNavBarShown = true;
  showBottomNav(bool isBottomNavShown) {
    if (isBottomNavBarShown == isBottomNavShown) return;
    isBottomNavBarShown = isBottomNavShown;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}

class UIRouter extends ChangeNotifier {
  static var mainNavigatorKey = GlobalKey<NavigatorState>();
  UIRouterBottomNavigation bottomNavigation = UIRouterBottomNavigation();

  static final navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.activity: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  // UIRouter() {
  // _startURIStreaming();
  // }

  static String lastScreenNameInHomeTab = "";
  static String lastScreenNameInLearnTab = "";
  static String lastScreenNameInDoTab = "";
  static String lastScreenNameInMessengerTab = "";
  static String lastScreenNameInMeTab = "";
  static String currentScreenName = "";

  static TabItem _selectedTabItem = TabItem.home;

  void selectTab(TabItem tabItem) {
    if (tabItem == currentTab) {
      // switch (tabItem) {
      //   case TabItem.Home:
      //     FirebaseAnalytics.instance.setCurrentScreen(
      //         screenName: AppAnalyticsConstants.HomeScreen);
      //     break;

      //   case TabItem.Messenger:
      //     FirebaseAnalytics.instance.setCurrentScreen(
      //         screenName: AppAnalyticsConstants.MessengerMainScreen);
      //     break;
      //   default:
      //     break;
      // }

      UIRouter.navigatorKeys[currentTab]!.currentState!
          .popUntil((route) => route.isFirst);
    } else {
      _selectedTabItem = tabItem;
      notifyListeners();
    }
    setCurrentScreenNameOnChangeRoute();
  }

  onTabTapped(TabItem newItem) {
    // debugPrint("Riad - new tab index ${newItem.value}");
    _selectedTabItem = newItem;
    // _selectedTabIndex = newIndex;
    // tabBarController.animateToPage(newIndex,
    //     duration: Duration(milliseconds: 500), curve: Curves.ease);
    // tabBarController.jumpToPage(newIndex);
    // notifyListeners();
  }

  static void setCurrentScreenName(String newScreenName, TabItem sentFromTab) {
    switch (sentFromTab) {
      case TabItem.home:
        lastScreenNameInHomeTab = newScreenName;
        if (TabItem.home == serviceLocator<UIRouter>().currentTab) {
          currentScreenName = newScreenName;
          debugPrint(
              'Heikal - setCurrentScreenName called with screen name $newScreenName');
        }

        break;

      case TabItem.activity:
        lastScreenNameInLearnTab = newScreenName;
        if (TabItem.activity == serviceLocator<UIRouter>().currentTab) {
          currentScreenName = newScreenName;
          debugPrint(
              'Heikal - setCurrentScreenName called with screen name $newScreenName');
        }
        break;

      case TabItem.settings:
        lastScreenNameInDoTab = newScreenName;
        if (TabItem.settings == serviceLocator<UIRouter>().currentTab) {
          currentScreenName = newScreenName;
          debugPrint(
              'Heikal - setCurrentScreenName called with screen name $newScreenName');
        }
        break;
    }

    currentScreenName = newScreenName;
  }

  static void setCurrentScreenNameOnChangeRoute() {
    switch (serviceLocator<UIRouter>().currentTab) {
      case TabItem.home:
        currentScreenName = lastScreenNameInHomeTab;
        break;

      case TabItem.activity:
        currentScreenName = lastScreenNameInLearnTab;
        break;

      case TabItem.settings:
        currentScreenName = lastScreenNameInDoTab;
        break;
    }

    debugPrint(
        'Heikal - setCurrentScreenName called with screen name $currentScreenName');
  }

  // void _startURIStreaming() {
  //   _streamSubscription = uriLinkStream.listen((Uri? uri) async {
  //     await handleIncomingLinks(uri);
  //   }, onError: (Object err) {
  //     // if (!mounted) return;

  //     print('got err: $err');
  //   });
  // }

// EasyLoading.instance
//       ..displayDuration = const Duration(milliseconds: 2000)
//       ..indicatorType = EasyLoadingIndicatorType.cubeGrid
//       ..loadingStyle = EasyLoadingStyle.custom
//       ..indicatorSize = 45.0
//       ..radius = 20.0
//       ..progressColor = Colors.yellow
//       ..backgroundColor = Colors.green
//       ..indicatorColor = Colors.yellow
//       ..textColor = Colors.yellow
//       ..maskColor = Colors.blue.withOpacity(0.5)
//       ..userInteractions = true
//       ..dismissOnTap = true
//       ..customAnimation = CustomAnimation();
  static configureEasyLoader() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 900000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..overlayEntry
      ..indicatorSize = 60
      ..indicatorWidget = DefaultContainer(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.primary700.withOpacity(0.25),
              AppColors.primary700.withOpacity(0.15),
              AppColors.primary700.withOpacity(0.1),
              AppColors.primary700.withOpacity(0.0),
            ],
          ),
        ),
        child: Image.asset(
          'assets/gif/loader3.gif',
          gaplessPlayback: true,
        ),
      )
      ..infoWidget = DefaultContainer(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.primary700.withOpacity(0.25),
              AppColors.primary700.withOpacity(0.15),
              AppColors.primary700.withOpacity(0.1),
              AppColors.primary700.withOpacity(0.0),
            ],
          ),
        ),
        child: Image.asset(
          'assets/gif/loader3.gif',
          gaplessPlayback: true,
        ),
      )
      ..textColor = Colors.white
      ..radius = 20
      ..backgroundColor = Colors.transparent
      ..maskColor = Colors.transparent // Set maskColor to transparent
      ..indicatorColor = Colors.white
      ..userInteractions = false
      ..boxShadow = <BoxShadow>[]
      ..dismissOnTap = false
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid;
  }

  static Future showEasyLoader({
    String? message,
    bool enableUserInteractions = false,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
  }) async {
    EasyLoading.instance.userInteractions = enableUserInteractions;

    EasyLoading.show(
      status: message ?? '',
      maskType: maskType ?? EasyLoadingMaskType.clear,
      indicator: DefaultContainer(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.primary700.withOpacity(0.25),
              AppColors.primary700.withOpacity(0.15),
              AppColors.primary700.withOpacity(0.1),
              AppColors.primary700.withOpacity(0.0),
            ],
          ),
        ),
        // padding: const EdgeInsets.only(
        //     top: kMainPadding, left: kMainPadding, right: kMainPadding),
        child: indicator ??
            Image.asset(
              'assets/gif/loader3.gif',
              height: 160,
              gaplessPlayback: true,
            ),
      ),
    );
  }

  //region STATIC
  static BuildContext getCurrentContext() {
    return mainNavigatorKey.currentContext!;
  }

  static Future<dynamic> pushReplacementScreen(Widget newScreen,
      {BuildContext? context,
      bool rootNavigator = false,
      required String pageName,
      bool showNavigator = false,
      PageTransitionType pushDirection = PageTransitionType.rightToLeft,
      Curve curve = Curves.linear,
      Duration duration = const Duration(milliseconds: 200),
      dynamic argumentReturned}) async {
    //  }) {
    // Navigator.of(context ?? getCurrentContext(), rootNavigator: rootNavigator)
    //     .pop(argumentReturned);
    // FirebaseAnalytics.instance.setCurrentScreen(screenName: pageName);

    return await Navigator.of(context ?? getCurrentContext(),
            rootNavigator: rootNavigator)
        .pushReplacement(
      PageTransition(
        child: newScreen,
        type: pushDirection,
        isIos: true,
        duration: duration,
        curve: curve,
        settings: RouteSettings(
          name: pageName,
          arguments: [showNavigator],
        ),
      ),
    );
  }

  static Future<dynamic> pushScreen(Widget newScreen,
      {BuildContext? context,
      required String pageName,
      bool rootNavigator = false,
      bool showNavigator = false,
      PageTransitionType pushDirection = PageTransitionType.rightToLeft,
      Curve curve = Curves.linear,
      Duration duration = const Duration(milliseconds: 200)}) async {
    return await Navigator.of(context ?? getCurrentContext(),
            rootNavigator: rootNavigator)
        .push(
      PageTransition(
        child: newScreen,
        type: pushDirection,
        isIos: true,
        duration: duration,
        curve: curve,
        settings: RouteSettings(
          name: pageName,
          arguments: [showNavigator],
        ),
      ),
    );
  }

  TabItem get currentTab => _selectedTabItem;
  set tabItem(TabItem newTabIndex) {
    _selectedTabItem = newTabIndex;
    // notifyListeners();
  }

  static popScreen(
      {BuildContext? context,
      bool rootNavigator = false,
      dynamic argumentReturned}) {
    Navigator.of(context ?? getCurrentContext(), rootNavigator: rootNavigator)
        .pop(argumentReturned);
  }

  static RestartApp({BuildContext? context}) {
    serviceLocator<UIRouter>().tabItem = TabItem.home;
    MyApp.restartApp(context ?? getCurrentContext());
  }

  static Future<T?> showAppBottomDrawer<T>({
    BuildContext? context,
    required List<Widget> options,
    Color backgroundColor = AppColors.grey50,
    Color drawerHandleColor = AppColors.grey300,
    Color seperatorColor = AppColors.grey100,
    Color optionBackgroundColor = AppColors.white,
    double borderRadius = 20,
    String? title,
  }) async {
    return showModalBottomSheet<T>(
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      context: context ?? getCurrentContext(),
      builder: (context) {
        return Container(
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                        color: drawerHandleColor,
                        borderRadius: BorderRadius.circular(70)),
                  ),
                ],
              ),
              if (title == null) const SizedBox(height: kHelpingPadding),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kMainPadding, vertical: kHelpingPadding),
                  child: Text(title, style: TextStyles.InterGrey700S16W600),
                ),
              ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  // physics: ClampingScrollPhysics(),
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => Divider(
                        height: 1.5,
                        color: seperatorColor,
                      ),
                  itemBuilder: (context, index) {
                    return Container(
                      color: optionBackgroundColor,
                      padding:
                          const EdgeInsets.symmetric(vertical: kMainPadding),
                      child: options.elementAt(index),
                    );
                  }),
              Container(height: 40, color: optionBackgroundColor),
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> showAppBottomDrawerWithCustomWidget<T>({
    BuildContext? context,
    required Widget child,
    Color backgroundColor = AppColors.grey100,
    Color drawerHandleColor = AppColors.grey300,
    Color bodyBackgroundColor = AppColors.white,
    double borderRadius = 20,
    bool isScrollControlled = true,
    double bottomPadding = 40,
    String? title,
    bool useRootNavigator = true,
  }) async {
    return await showModalBottomSheet<T>(
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      context: context ?? getCurrentContext(),
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: kHelpingPadding),
              Container(
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                    color: drawerHandleColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
              if (title == null) const SizedBox(height: 9),
              if (title != null)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kMainPadding, vertical: kHelpingPadding),
                    child: Text(
                      title,
                      style: TextStyles.InterGrey700S16W600,
                    ),
                  ),
                ),
              Container(color: bodyBackgroundColor, child: child),
              Container(height: bottomPadding, color: bodyBackgroundColor),
            ],
          ),
        );
      },
    );
  }
}
