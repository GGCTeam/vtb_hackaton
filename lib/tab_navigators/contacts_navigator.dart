import 'package:flutter/material.dart';
import 'package:vtb_hackaton/bottom_navigation.dart';
import 'package:vtb_hackaton/screens/contacts_screen.dart';

class ContactsNavigatorRoutes {
  static const String root = '/';
}

class ContactsNavigator extends StatelessWidget {
  ContactsNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      ContactsNavigatorRoutes.root: (context) => ContactsScreen(
        title: tabName[tabItem],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: ContactsNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
