import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/screens/MainScaffoldVM.dart';
import 'package:teachy_tec/screens/SignInScreen.dart';
import 'package:teachy_tec/screens/SignInScreenVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/utils/AppUtility.dart';
import 'package:teachy_tec/utils/Routing/TabItem.dart';
import 'package:teachy_tec/utils/Routing/TabNavigator.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class MainScaffold extends StatefulWidget {
  MainScaffold({
    required this.model,
    super.key,
  });
  final MainScaffoldVM model;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final _controller = NotchBottomBarController(index: 0);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.model,
        child: Consumer<UIRouter>(
          builder: (context, router, _) {
            widget.model.setCurrentContext(context);
            Widget getBodyWidget() {
              if (serviceLocator<FirebaseAuth>().currentUser == null) {
                return SignInScreen(model: SignInScreenVM());
              }

              // if (widget.model.currentUserAppConfiguration != null) {
              //   if (widget.model.currentUserAppConfiguration!.updateRequired) {
              //      return const OutOfDateScreen();
              //   }
              // }

              return Stack(
                children: [
                  Offstage(
                    offstage: router.currentTab != TabItem.home,
                    child: TabNavigator(
                      navigatorKey: UIRouter.navigatorKeys[TabItem.home]!,
                      tabItem: TabItem.home,
                      showBottomNav: router.bottomNavigation.showBottomNav,
                    ),
                  ),
                  Offstage(
                    offstage: router.currentTab != TabItem.activity,
                    child: TabNavigator(
                      navigatorKey: UIRouter.navigatorKeys[TabItem.activity]!,
                      tabItem: TabItem.activity,
                      showBottomNav: router.bottomNavigation.showBottomNav,
                    ),
                  ),
                  Offstage(
                    offstage: router.currentTab != TabItem.settings,
                    child: TabNavigator(
                      navigatorKey: UIRouter.navigatorKeys[TabItem.settings]!,
                      tabItem: TabItem.settings,
                      showBottomNav: router.bottomNavigation.showBottomNav,
                    ),
                  ),
                ],
              );
            }

            return PopScope(
              onPopInvoked: (didPop) async {
                final isFirstRouteInCurrentTab = !await UIRouter
                    .navigatorKeys[router.currentTab]!.currentState!
                    .maybePop();
                if (isFirstRouteInCurrentTab) {
                  if (router.currentTab != TabItem.home) {
                    router.selectTab(TabItem.home);
                  }
                }
              },
              child: Directionality(
                textDirection: AppUtility.isDirectionalitionalityLTR()
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  body: Consumer<MainScaffoldVM>(
                      builder: (context, model, _) => SafeArea(
                            bottom: false,
                            child: getBodyWidget(),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //       bottom:
                            //           router.bottomNavigation.isBottomNavBarShown
                            //               ? 56
                            //               : 0),
                            //   child: getBodyWidget(),
                            // )
                          )),
                  resizeToAvoidBottomInset: true,
                  bottomNavigationBar: serviceLocator<FirebaseAuth>()
                              .currentUser ==
                          null
                      ? null
                      : Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedNotchBottomBar(
                                notchBottomBarController: _controller,
                                color: AppColors.black,
                                blurOpacity: 0.90,
                                showLabel: false,
                                kBottomRadius: 0.0,
                                notchColor: AppColors.black,

                                /// restart app if you change removeMargins
                                removeMargins: true,
                                bottomBarWidth: 200,
                                durationInMilliSeconds: 300,
                                bottomBarItems: [
                                  BottomBarItem(
                                    inActiveItem: SvgPicture.asset(
                                      'assets/svg/home.svg',
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.white, BlendMode.srcIn),
                                    ),
                                    activeItem: SvgPicture.asset(
                                      'assets/svg/home.svg',
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.primary700,
                                          BlendMode.srcIn),
                                    ),
                                    itemLabel: '',
                                  ),
                                  BottomBarItem(
                                    inActiveItem: SvgPicture.asset(
                                      'assets/svg/fire.svg',
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.white, BlendMode.srcIn),
                                    ),
                                    activeItem: SvgPicture.asset(
                                      'assets/svg/fire.svg',
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.primary700,
                                          BlendMode.srcIn),
                                    ),
                                    itemLabel: '',
                                  ),
                                  BottomBarItem(
                                    inActiveItem: SvgPicture.asset(
                                      'assets/svg/settings.svg',
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.white, BlendMode.srcIn),
                                    ),
                                    activeItem: SvgPicture.asset(
                                      'assets/svg/settings.svg',
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.primary700,
                                          BlendMode.srcIn),
                                    ),
                                    itemLabel: '',
                                  ),
                                ],
                                onTap: (index) async {
                                  /// perform action on tab change and to update pages you can update pages without pages
                                  // log('current selected index $index');
                                  if (router.currentTab == TabItem.home &&
                                      index == 0) {
                                    if (!await UIRouter
                                        .navigatorKeys[router.currentTab]!
                                        .currentState!
                                        .maybePop()) {
                                      // widget.model.homeScreenVM.scrollToTopOgNesFeed();
                                    }
                                  }

                                  var item = TabItem.values.firstWhere(
                                      (element) => element.value == index);
                                  router.selectTab(item);
                                  Provider.of<UIRouter>(context, listen: false)
                                      .onTabTapped(item);
                                },
                                kIconSize: 26.0,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            );
          },
        ));
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
