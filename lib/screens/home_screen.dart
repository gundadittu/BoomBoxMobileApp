import 'package:flutter/material.dart';

import '../provider/streaming_auth_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          return FutureBuilder<void>(
            future: Provider.of<StreamingAuthManager>(context, listen: false)
                .authorizeAppleMusic(),
            builder: (context, snapshot) {
              print('In Builder');
            },
          );
        },
        child: Text("Connect Apple Music"),
      ),
    );
  }
}
