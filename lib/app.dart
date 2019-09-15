import 'package:flutter/material.dart';
import 'package:vtb_hackaton/bottom_navigation.dart';
import 'package:vtb_hackaton/tab_navigators/invoices_navigator.dart';
import 'package:vtb_hackaton/tab_navigators/transactions_navigator.dart';
import 'package:vtb_hackaton/tab_navigators/contacts_navigator.dart';
import 'package:vtb_hackaton/tab_navigators/profile_navigator.dart';
import 'package:vtb_hackaton/data/session.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  bool sessionWasReceived = false;

  TabItem _currentTab = TabItem.invoices;

  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.invoices: GlobalKey<NavigatorState>(),
    TabItem.transactions: GlobalKey<NavigatorState>(),
    TabItem.contacts: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();

    getSession(context);
  }

  Future<void> getSession(BuildContext context) async {
    await Session.instance.get();
    setState(() {
      sessionWasReceived = true;
    });
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.invoices) {
            // select 'main' tab
            _selectTab(TabItem.invoices);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: !sessionWasReceived ? Center(child: CircularProgressIndicator()) : Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.invoices),
          _buildOffstageNavigator(TabItem.transactions),
          _buildOffstageNavigator(TabItem.contacts),
          _buildOffstageNavigator(TabItem.profile),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: _correctTabNavigator(tabItem),
    );
  }

  Widget _correctTabNavigator(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.invoices:
        return InvoicesNavigator(
          navigatorKey: _navigatorKeys[tabItem],
          tabItem: tabItem,
        );
      case TabItem.transactions:
        return TransactionsNavigator(
          navigatorKey: _navigatorKeys[tabItem],
          tabItem: tabItem,
        );
      case TabItem.contacts:
        return ContactsNavigator(
          navigatorKey: _navigatorKeys[tabItem],
          tabItem: tabItem,
        );
      case TabItem.profile:
        return ProfileNavigator(
          navigatorKey: _navigatorKeys[tabItem],
          tabItem: tabItem,
        );
    }

    return null;
  }
}
