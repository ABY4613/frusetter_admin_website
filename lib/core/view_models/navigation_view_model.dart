import 'package:flutter/material.dart';

enum NavigationItem {
  dashboard,
  mealsPlanning,
  subscriptions,
  deliveryFleet,
  financials,
  feedback
}

class NavigationViewModel extends ChangeNotifier {
  NavigationItem _selectedItem = NavigationItem.dashboard;

  NavigationItem get selectedItem => _selectedItem;

  void setNavigationItem(NavigationItem item) {
    if (_selectedItem != item) {
      _selectedItem = item;
      notifyListeners();
    }
  }
}
