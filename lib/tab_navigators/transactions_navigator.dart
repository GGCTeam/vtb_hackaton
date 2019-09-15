import 'package:flutter/material.dart';
import 'package:vtb_hackaton/bottom_navigation.dart';
import 'package:vtb_hackaton/screens/transactions_screen.dart';

class TransactionsNavigatorRoutes {
  static const String root = '/';
}

class TransactionsNavigator extends StatelessWidget {
  TransactionsNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TransactionsNavigatorRoutes.root: (context) => TransactionsScreen(
        title: tabName[tabItem],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TransactionsNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
