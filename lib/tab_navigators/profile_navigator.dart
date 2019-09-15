import 'package:flutter/material.dart';
import 'package:vtb_hackaton/bottom_navigation.dart';
import 'package:vtb_hackaton/screens/profile_screen.dart';

class ProfileNavigatorRoutes {
  static const String root = '/';
}

class ProfileNavigator extends StatelessWidget {
  ProfileNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      ProfileNavigatorRoutes.root: (context) => ProfileScreen(
        title: tabName[tabItem],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: ProfileNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
