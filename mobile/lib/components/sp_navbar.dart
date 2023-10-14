import 'package:flutter/material.dart';
import 'package:mobile/components/sp_additems.dart';
import 'package:mobile/sp_homepage.dart';
import 'package:mobile/sp_orderspage.dart';
import 'package:mobile/sp_profilepage.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class SPNavBar extends StatefulWidget {
  final Map<String, dynamic> userData;

  SPNavBar({required this.userData});

  @override
  State<SPNavBar> createState() => _SPNavBarState(userData: userData);
}

class _SPNavBarState extends State<SPNavBar> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
 // Initialize with a default value

  final Map<String, dynamic> userData;

  _SPNavBarState({required this.userData});

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("userData: ${widget.userData}");
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const ["Home","Profile", "My Shop","Orders"],
        icons: const [
          Icons.home,
          Icons.person,
          Icons.shop,
          Icons.shopping_basket,
        ],
        badges: [
          null,
          null,
          null,
          const MotionBadgeWidget(
            text: '9',
            textColor: Colors.white,
            color: Colors.red,
            size: 18,
          ),
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Color.fromARGB(255, 0, 0, 0),
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color.fromARGB(255, 255, 255, 255),
        tabIconSelectedColor: const Color.fromARGB(255, 0, 0, 0),
        tabBarColor: Color.fromARGB(255, 248, 204, 57),
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: <Widget>[
          SPHomePage(userData: userData), // Pass userData to Home Page
          SPProfilePage(userData: userData), // Pass userData to Profile Page
          SPAddItems(userData: userData),
          SPOrdersPage(userData: userData), // Pass userData to Orders Page
        ],
      ),
    );
  }
}