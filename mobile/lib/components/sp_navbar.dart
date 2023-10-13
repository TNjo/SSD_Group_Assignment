import 'package:mobile/sp_homepage.dart';
import 'package:mobile/sp_orderspage.dart';
import 'package:mobile/sp_profilepage.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class SPNavBar extends StatefulWidget {
  final int initialTabIndex;
  final Map<String, dynamic> userData; // Add this line

  SPNavBar({this.initialTabIndex = 0, required this.userData}); // Add `required` to userData parameter

  @override
  State<SPNavBar> createState() => _SPNavBarState();
}


class _SPNavBarState extends State<SPNavBar> with TickerProviderStateMixin{
   MotionTabBarController? _motionTabBarController;
  int _selectedTabIndex = 1;
  int _receivedArgument = 1; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: _receivedArgument, // Use the received argument as initial index
      length: 3,
      vsync: this,
    );
    _selectedTabIndex = _receivedArgument; // Set initial index based on received argument
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic argument = ModalRoute.of(context)?.settings.arguments;

    // Wrap the received argument update inside setState
    if (argument != null && argument is int) {
      setState(() {
        _receivedArgument = argument; // Update received argument
        print("Received Argument: $_receivedArgument");
      });
    }

    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const ["Profile","Home","Orders"],
        icons: const [
          Icons.person,
          Icons.home,
          Icons.shopping_basket,
        ],
        badges: [
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
            _selectedTabIndex = value; // Update _selectedTabIndex
            _motionTabBarController!.index = value;
            print("Selected Tab Index: $_selectedTabIndex");
            _receivedArgument = _selectedTabIndex;
            print("Received Argument: $_receivedArgument");
          });
        },
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: <Widget>[
           SPProfilePage(), // Profile Page
           SPHomePage(), // Home Page
           SPOrdersPage(), // Orders Page
        ],
      ),
    );
  }
}





