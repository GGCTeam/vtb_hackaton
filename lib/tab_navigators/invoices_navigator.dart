import 'package:flutter/material.dart';
import 'package:vtb_hackaton/bottom_navigation.dart';
import 'package:vtb_hackaton/screens/create_invoices_for_bill_screen.dart';
import 'package:vtb_hackaton/screens/invoices_screen.dart';
import 'package:vtb_hackaton/screens/invoices_purchases_detail_screen.dart';

class InvoicesNavigatorRoutes {
  static const String root = '/';
  static const String invoices_for_bill_detail = '/invoices_for_bill_detail';
  static const String invoices_for_bill_create = '/invoices_for_bill_create';
}

class InvoicesNavigator extends StatelessWidget {
  InvoicesNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  void _pushDetail(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[InvoicesNavigatorRoutes.invoices_for_bill_detail](context),
      ),
    );
  }

  void _pushCreate(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[InvoicesNavigatorRoutes.invoices_for_bill_create](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      InvoicesNavigatorRoutes.root: (context) => InvoicesScreen(
        title: tabName[tabItem],
        onCreatePush: () => _pushCreate(context),
        onDetailPush: () => _pushDetail(context),
      ),
      InvoicesNavigatorRoutes.invoices_for_bill_detail: (context) => InvoicesPurchasesDetailScreen(
        // title: "Разделение счета",
      ),
      InvoicesNavigatorRoutes.invoices_for_bill_create: (context) => CreateInvoicesForBillScreen(
        title: "Разделение счета",
      ),
//      InvoicesNavigatorRoutes.root: (context) => ColorsListPage(
//        color: activeTabColor[tabItem],
//        title: tabName[tabItem],
//        onPush: (materialIndex) =>
//            _push(context, materialIndex: materialIndex),
//      ),
//      InvoicesNavigatorRoutes.invoice_detail: (context) => ColorDetailPage(
//        color: activeTabColor[tabItem],
//        title: tabName[tabItem],
//        materialIndex: materialIndex,
//      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: InvoicesNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
