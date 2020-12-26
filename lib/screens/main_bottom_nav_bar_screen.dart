// Flutter + Dart dependencies
import 'package:flutter/material.dart';

// Internal dependencies
import '../provider/streaming_auth_manager.dart';

import 'package:provider/provider.dart';

import './home_screen.dart';
// External dependencies

class MainBottomNavBar extends StatefulWidget {
  MainBottomNavBar({Key key}) : super(key: key);

  @override
  _MainBottomNavBarState createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _screenOptions = <Widget>[
    HomeScreen(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // Future<void> _authorizeAppleMusic() async {
  //   await Provider.of<StreamingAuthManager>(context, listen: false)
  //       .authorizeAppleMusic();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        // remove this center widget after building actual pages
        child: _screenOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
