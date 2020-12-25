import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:convert';

/* 
Notes: 
- Make sure SentryFlutter is initialized in main.dart
Relevant Docs/Links: 
- https://pub.dev/packages/sentry 
- sentry portal: https://sentry.io/organizations/boombox-apps/issues/?project=5563418
*/
class ErrorManager {
  static bool get isInDebugMode {
    // Assume you're in production mode.
    bool inDebugMode = false;

    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);

    return inDebugMode;
  }

  static showErrorDialog(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
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

  static Future<void> addContext(String message, Object obj) async {
    if (!isInDebugMode) {
      Sentry.configureScope((scope) => scope.setContexts(message, obj));
    } else {
      print(message + ': ' + jsonEncode(obj));
    }
  }

  static Future<void> reportError(dynamic error, dynamic stackTrace) async {
    print('ErrorManger.reportError: Caught error: $error');
    if (!isInDebugMode) {
      // Send the Exception and Stacktrace to Sentry in Production mode.
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    } else {
      // Print the full stacktrace in debug mode.
      print(stackTrace);
    }
  }
}
