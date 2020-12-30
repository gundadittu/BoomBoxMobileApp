import 'package:flutter/material.dart';

import '../providers/streaming_auth_manager.dart';
import 'package:provider/provider.dart';

class StreamingAuthScreen extends StatefulWidget {
  @override
  _StreamingAuthScreenState createState() => _StreamingAuthScreenState();
}

class _StreamingAuthScreenState extends State<StreamingAuthScreen> {
  // bool isLoadingStreamingAuth = false;

  void _startAppleMusicAuth() {
    // setState(() {
    //   isLoadingStreamingAuth = true;
    // });
    Provider.of<StreamingAuthManager>(context, listen: false)
        .authorizeAppleMusic(_onAuthSuccess, _onAuthFailure);
  }

  void _startSpotifyAuth() {
    // setState(() {
    //   isLoadingStreamingAuth = true;
    // });
    Provider.of<StreamingAuthManager>(context, listen: false)
        .authorizeSpotify(_onAuthSuccess, _onAuthFailure);
  }

  void _onAuthSuccess() {
    // setState(() {
    //   isLoadingStreamingAuth = false;
    // });
    print("STREAMING AUTH SUCCESS - recieved in UI");
  }

  void _onAuthFailure(StreamingAuthError error) {
    // setState(() {
    //   isLoadingStreamingAuth = false;
    // });
    print("STREAMING AUTH FAILED - recieved in UI");

    // TODO: show error message based on error type
  }

// () {
//               return FutureBuilder<void>(
//                 future:
//                     Provider.of<StreamingAuthManager>(context, listen: false)
//                         .authorizeAppleMusic(),
//                 builder: (context, snapshot) {
//                   print('In AM Builder');
//                 },
//               );
//             }
// () {
//               return FutureBuilder<void>(
//                 future:
//                     Provider.of<StreamingAuthManager>(context, listen: false)
//                         .authorizeSpotify(),
//                 builder: (context, snapshot) {
//                   print('In Spotify Builder');
//                 },
//               );
//             }
  @override
  Widget build(BuildContext context) {
    // if (isLoadingStreamingAuth) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: _startAppleMusicAuth,
            child: Text("Connect Apple Music"),
          ),
          RaisedButton(
            onPressed: _startSpotifyAuth,
            child: Text("Connect Spotify"),
          ),
        ],
      ),
    );
  }
}
