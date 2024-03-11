enum TabItem {
  home(value: 0),
  activity(value: 1),
  settings(value: 2);

  final int value;
  const TabItem({required this.value});
}

// enum loggingItems { signIn, SignUp }
const Map<TabItem, String> tabName = {
  TabItem.home: 'Home',
  TabItem.activity: 'Activity',
  TabItem.settings: 'Settings',
};
