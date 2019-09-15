import 'package:flutter/material.dart';

enum TabItem { invoices, transactions, contacts, profile }

Map<TabItem, String> tabName = {
  TabItem.invoices: 'Счета',
  TabItem.transactions: 'Транзации',
  TabItem.contacts: 'Контакты',
  TabItem.profile: 'Профиль',
};

Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.invoices: Colors.indigo,
  TabItem.transactions: Colors.indigo,
  TabItem.contacts: Colors.indigo,
  TabItem.profile: Colors.indigo,
};

Map<TabItem, IconData> tabIcons = {
  TabItem.invoices: Icons.pie_chart_outlined,
  TabItem.transactions: Icons.attach_money,
  TabItem.contacts: Icons.contacts,
  TabItem.profile: Icons.tag_faces,
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.invoices),
        _buildItem(tabItem: TabItem.transactions),
        _buildItem(tabItem: TabItem.contacts),
        _buildItem(tabItem: TabItem.profile),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text = tabName[tabItem];
    IconData icon = tabIcons[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? activeTabColor[item] : Colors.grey;
  }
}
