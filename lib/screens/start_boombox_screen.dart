import 'package:BoomBoxApp/providers/streaming_library_manager.dart';
// import 'package:BoomBoxApp/provider/streaming_auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_library_songs_boombox_screen.dart';

class StartBoomboxScreen extends StatefulWidget {
  @override
  _StartBoomboxScreenState createState() => _StartBoomboxScreenState();
}

class _StartBoomboxScreenState extends State<StartBoomboxScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  final allTabs = <Tab>[
    new Tab(icon: new Icon(Icons.arrow_forward)),
    // new Tab(icon: new Icon(Icons.arrow_downward)),
    // new Tab(icon: new Icon(Icons.arrow_back)),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: allTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<StreamingLibraryManager>(context, listen: false)
          .populateAllLibraryData(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Songs'),
            leading: Container(),
            backgroundColor: Colors.transparent,
            bottom: new TabBar(
              controller: tabController,
              tabs: allTabs,
            ),
          ),
          body: !(snapshot.connectionState == ConnectionState.done)
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    AddLibrarySongsBoomboxScreen(),
                  ],
                ),
        );
      },
    );
  }
}
