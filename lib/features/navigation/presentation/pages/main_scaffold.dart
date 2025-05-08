import 'package:flutter/material.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/calendar_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/menu_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/profile_page.dart';
import 'package:fmpglobalinc/features/map/presentation/pages/map_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/widgets/bottom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MapPage(onNavigateToTab: _onPageChanged),
      MenuPage(onNavigateToTab: _onPageChanged),
      const CalendarPage(),
      ProfilePage(onNavigateToTab: _onPageChanged),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
      ),
    );
  }
}
