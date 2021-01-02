import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:BoomBoxApp/redux/auth/auth_actions.dart';
import 'package:BoomBoxApp/redux/streaming_auth/streaming_auth_state.dart';
import 'package:BoomBoxApp/screens/streaming_auth_screen/streaming_auth_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class StreamingAuthScreen extends StatefulWidget {
  @override
  _StreamingAuthScreenState createState() => _StreamingAuthScreenState();
}

class _StreamingAuthScreenState extends State<StreamingAuthScreen> {
  static void showStreamingAuthResultDialog(
      BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StreamingAuthScreenModel>(
      converter: (store) => StreamingAuthScreenModel.fromStore(store),
      onDidChange: (screenModel) {
        // TODO: show appropriate dialog + set statys to complete
        if (screenModel.authorizeNewStreamingAccountStatus ==
            AuthorizeNewStreamingAccountStatus.success) {
          showStreamingAuthResultDialog(
              context, "Success", "Your streaming account has been linked!");
        } else if (screenModel.authorizeNewStreamingAccountStatus ==
            AuthorizeNewStreamingAccountStatus.failureUnknown) {
          showStreamingAuthResultDialog(context, "Error",
              "Something went wrong. We couldn't link your streaming account. We've been notified.");
        } else if (screenModel.authorizeNewStreamingAccountStatus ==
            AuthorizeNewStreamingAccountStatus.failureIncompatibleAccount) {
          showStreamingAuthResultDialog(
              context, "Error", "Your streaming account is incompatible.");
        } else if (screenModel.authorizeNewStreamingAccountStatus ==
            AuthorizeNewStreamingAccountStatus
                .failureIncompatibleDevicePlatform) {
          showStreamingAuthResultDialog(context, "Error",
              "This streaming service is not available on this device yet.");
        } else if (screenModel.authorizeNewStreamingAccountStatus ==
            AuthorizeNewStreamingAccountStatus.failurePermissionDeniedByUser) {
          showStreamingAuthResultDialog(context, "Permission Denied",
              "You need to give us permission to link your streaming account.");
        } else if (screenModel.authorizeNewStreamingAccountStatus ==
            AuthorizeNewStreamingAccountStatus.failureSubscriptionRequired) {
          showStreamingAuthResultDialog(context, "Subscription Required",
              "You need to upgrade your streaming subscription to link your account.");
        }
      },
      builder: (_, screenModel) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TODO: SHOW EXISTING STREAMING ACCOUNT + OPTION TO DISCONNECT

              // TODO: DISABLE BUTTON if that streaming account is already connnected
              RaisedButton(
                onPressed: () => screenModel.authorizeAppleMusic(),
                child: Text("Connect Apple Music"),
              ),
              RaisedButton(
                onPressed: () => screenModel.authorizeSpotify(),
                child: Text("Connect Spotify"),
              ),
              // RaisedButton(
              //   onPressed: signOut,
              //   child: Text("Sign out"),
              // ),
            ],
          ),
        );
      },
    );
  }
}
