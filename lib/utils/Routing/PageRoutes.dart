class PageRoutes {
  static const Model = 'Model';

  // Learn Tab
  // Menu Tab
  static const PageDetails MenuItemsScreen = PageDetails(
    pageName: 'MenuItemsScreen',
    isBottomBarShown: true,
  );
  static const PageDetails PublishedDishMainScreen = PageDetails(
    pageName: 'PublishedDishMainScreen',
  );
  // Alcoholic Tab
  static const PageDetails BarItemsScreen = PageDetails(
    pageName: 'BarItemsScreen',
    isBottomBarShown: true,
  );
  static const PageDetails PublishedBarMainScreen = PageDetails(
    pageName: 'PublishedBarMainScreen',
  );

  // Policy Tab
  static const PageDetails PolicyItemsScreen = PageDetails(
    pageName: 'PolicyItemsScreen',
    isBottomBarShown: true,
  );

  static const PageDetails PublishedPolicyMainScreen = PageDetails(
    pageName: 'PublishedPolicyMainScreen',
  );
}

class PageDetails {
  final String pageName;
  final bool isBottomBarShown;
  const PageDetails({required this.pageName, this.isBottomBarShown = false});
}
