// Flutter + Dart dependencies
import 'package:BoomBoxApp/providers/streaming_library_manager.dart';
import 'package:BoomBoxApp/screens/start_boombox_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'streaming_auth_screen.dart';
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
    StreamingAuthScreen(),
    // Text(
    //   'Index 1: Business',
    //   style: optionStyle,
    // ),
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

  void _showStartBoomboxScreen(BuildContext context) {
    // TODO: need to check if user has a connected streaming account + set display name + photo
    // if not, then they shouldn't be able to add songs -> show different view 

    final streamingLibraryManager =
        Provider.of<StreamingLibraryManager>(context, listen: false);
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * .9,
          child: ChangeNotifierProvider.value(
            value: streamingLibraryManager,
            child: StartBoomboxScreen(),
          ),
        );
      },
    );
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.business),
          //   label: 'Business',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _showStartBoomboxScreen(context),
        child: new Icon(Icons.radio),
        elevation: 4.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
