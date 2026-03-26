import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

/// Scaffold com navbar customizado
class ScaffoldWithNavbar extends StatelessWidget {
  final Widget body;
  final List<BottomNavigationBarItem> navItems;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final String title;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;

  const ScaffoldWithNavbar({
    super.key,
    required this.body,
    required this.navItems,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.title,
    this.appBarActions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        actions: appBarActions,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
