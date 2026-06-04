import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:salespersontracking/Pages/Home/Home.dart';
import 'package:salespersontracking/Pages/Checkin-outList.dart/CheckInList.dart';
import 'package:salespersontracking/Pages/Profile/Profile.dart';
import 'package:salespersontracking/Pages/Reports/reportsMain.dart';
import 'package:salespersontracking/Pages/Tracking/Tracking.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({Key? key, this.initialIndex = 2}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  // List of screens for the navigation bar
  final List<Widget> _screens = [
    const Tracking(), // Index 0: Appointment
    const ReportsMain(), // Index 1: Activity
    const Home(), // Index 2: Home
    const CheckInList(), // Index 3: Check-In
    const Profile(), // Index 4: Profile
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          Icon(
            Icons.event_note,
            size: 30,
            color: _selectedIndex == 0 ? Stylecustomer.CrmColor : Colors.white,
          ),
          Icon(
            Icons.analytics,
            size: 30,
            color: _selectedIndex == 1 ? Stylecustomer.CrmColor : Colors.white,
          ),
          Icon(
            Icons.home,
            size: 30,
            color: _selectedIndex == 2 ? Stylecustomer.CrmColor : Colors.white,
          ),
          Icon(
            Icons.timer,
            size: 30,
            color: _selectedIndex == 3 ? Stylecustomer.CrmColor : Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: _selectedIndex == 4 ? Stylecustomer.CrmColor : Colors.white,
          ),
        ],
        color: Stylecustomer.CrmColor,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
