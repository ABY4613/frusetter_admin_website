import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/screens/dashboard/dashboard_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/screens/subscriptions/subscriptions_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/side_bar_widget.dart';
// Updated import path for DeliveriesScreen
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/screens/deliveries/deliveries_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/screens/feedback/feedback_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/screens/financials/financials_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/screens/meals_planning/meals_planning_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/widgets/frusette_loader.dart';
import 'package:provider/provider.dart';
import '../core/view_models/navigation_view_model.dart';
import '../core/theme/app_colors.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1000;

        if (isMobile) {
          return Scaffold(
            backgroundColor: AppColors.dashboardBackground,
            drawer: const Drawer(
              backgroundColor: AppColors.white,
              child: SideBarWidget(),
            ),
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.black),
              title: Consumer<NavigationViewModel>(
                builder: (context, viewModel, child) => Text(
                  _getTitleForNavigationItem(viewModel.selectedItem),
                  style: const TextStyle(
                      color: AppColors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: Consumer<NavigationViewModel>(
              builder: (context, viewModel, child) {
                return _ScreenLoader(selectedItem: viewModel.selectedItem);
              },
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.dashboardBackground,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SideBarWidget(),
                Expanded(
                  child: Consumer<NavigationViewModel>(
                    builder: (context, viewModel, child) {
                      return _ScreenLoader(
                          selectedItem: viewModel.selectedItem);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  String _getTitleForNavigationItem(NavigationItem item) {
    switch (item) {
      case NavigationItem.dashboard:
        return 'Dashboard';
      case NavigationItem.mealsPlanning:
        return 'Meals Planning';
      case NavigationItem.subscriptions:
        return 'Subscriptions';
      case NavigationItem.deliveryFleet:
        return 'Delivery Fleet';
      case NavigationItem.financials:
        return 'Payments & Billing';
      case NavigationItem.feedback:
        return 'Feedback';
    }
  }
}

class _ScreenLoader extends StatefulWidget {
  final NavigationItem selectedItem;

  const _ScreenLoader({Key? key, required this.selectedItem}) : super(key: key);

  @override
  State<_ScreenLoader> createState() => _ScreenLoaderState();
}

class _ScreenLoaderState extends State<_ScreenLoader> {
  bool _isLoading = false;
  late NavigationItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.selectedItem;
  }

  @override
  void didUpdateWidget(_ScreenLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      setState(() {
        _isLoading = true;
        _currentItem = widget.selectedItem;
      });

      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: AppColors.white,
        child: const Center(
          child: FrusetteLoader(
            size: 80,
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    switch (_currentItem) {
      case NavigationItem.dashboard:
        return const DashboardScreen();
      case NavigationItem.mealsPlanning:
        return const MealsPlanningScreen();
      case NavigationItem.subscriptions:
        return const SubscriptionsScreen();
      case NavigationItem.deliveryFleet:
        return const DeliveriesScreen();
      case NavigationItem.financials:
        return const FinancialsScreen();
      case NavigationItem.feedback:
        return const FeedbackScreen();
    }
  }
}
