import 'package:BoomBoxApp/error_manager.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import '../providers/streaming_auth_manager.dart';

class SpotifyAuthManager {
  static const _spotifyChannel =
      const MethodChannel('streaming.boombox.app/spotify');
  static const _callbackChannel = const MethodChannel('spotifyAuthCallbacks');

  String userToken;

  Function(String) sessionSuccessCallback;
  Function(StreamingAuthError) sessionFailureCallback;

  static final SpotifyAuthManager _singleton =
      new SpotifyAuthManager._internal();

  SpotifyAuthManager._internal() {}

  factory SpotifyAuthManager() {
    return _singleton;
  }

  Future<void> authorize(
      Function(String) successCallback, Function(StreamingAuthError) failureCallback) async {
    try {
      if (!Platform.isIOS) {
        throw StreamingAuthError(
            StreamingAuthErrorType.incompatibleDevicePlatform);
      }
      
      sessionSuccessCallback = successCallback;
      sessionFailureCallback = failureCallback;
      
      _callbackChannel.setMethodCallHandler(_spotifySessionCallbackHandler);
      
      await _initiateSession();
    } on StreamingAuthError catch (e) {
         failureCallback(e); 
    } on Exception catch (e, stackTrace) { 
      ErrorManager.reportError(e, stackTrace); 
      throw StreamingAuthError(StreamingAuthErrorType.unknown);
    }
    // TODO in player: check if user is premium user: https://spotify.github.io/ios-sdk/html/Protocols/SPTAppRemoteUserAPI.html#//api/name/fetchCapabilitiesWithCallback:
  }

  Future<void> _initiateSession() async {
    bool initializationStarted =
        await _spotifyChannel.invokeMethod('initiateSpotifySession');
    if (initializationStarted == false) {
      final e = StreamingAuthError(StreamingAuthErrorType.unknown);
      ErrorManager.reportError(e, StackTrace.current);
      throw e;
    }
  }

  void _didInitiateSession(String accessToken) {
    userToken = accessToken;
    ErrorManager.addContext(
        "Recieved spotify user token", {accessToken: accessToken});
    sessionSuccessCallback(accessToken);
  }

  void _didFailSession(String errorMessage) {
    ErrorManager.reportError(Exception(errorMessage), null);
    sessionFailureCallback(StreamingAuthError(StreamingAuthErrorType.unknown));
  }

  Future<void> _spotifySessionCallbackHandler(MethodCall call) async {
    switch (call.method) {
      case 'didInitiateSession':
        final accessToken = call.arguments["accessToken"];
        _didInitiateSession(accessToken);
        break;
      case 'didFailSession':
        final errorMessage = call.arguments["errorMessage"];
        _didFailSession(errorMessage);
        break;
      default:
        print(
            ' Ignoring invoke from native. This normally shouldn\'t happen.');
            ErrorManager.reportError("Ignoring invoke from native. This normally shouldn\'t happen.", { "method": call.method, "arguments": call.arguments });
    }
  }
}
