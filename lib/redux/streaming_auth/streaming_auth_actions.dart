import 'package:BoomBoxApp/cloudStore/streaming_account_store_service.dart';
import 'package:BoomBoxApp/models/user_streaming_account_store_item.dart';
import 'package:BoomBoxApp/providers/streaming_auth_manager.dart';
import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:BoomBoxApp/streaming/apple_music_auth_manager.dart';
import 'package:BoomBoxApp/streaming/spotify_auth_manager.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import '../../error_manager.dart';
import 'streaming_auth_state.dart';

ThunkAction<AppState> loadExistingStreamingAuth() {
  return (Store<AppState> store) async {
    final existingStreamingAccount =
        await StreamingAccountStoreService.fetchExistingStreamingAccountItem();
    ErrorManager.addContext("Fetched Current User Streaming Account Store Item",
        existingStreamingAccount);

    if (existingStreamingAccount == null) {
      // TODO: log this
      ErrorManager.addContext(
          "Returning void since user streaming account store item was null.",
          null);
      return;
    }

    final accountType = existingStreamingAccount.accountType;
    switch (accountType) {
      case UserStreamingAccountStoreItemAccountType.appleMusic:
        store.dispatch(authorizeAppleMusicAction());
        break;
      case UserStreamingAccountStoreItemAccountType.spotify:
        store.dispatch(authorizeSpotifyAction());
        break;
    }
  };
}

ThunkAction<AppState> authorizeSpotifyAction() {
  return (Store<AppState> store) async {
    final spotifyAuthManager = SpotifyAuthManager();

    void _onSpotifyAuthSuccess(String accessToken) async {
      final data = {
        'accountType': "spotify",
        'spotifyAccessToken': accessToken,
      };

      try {
        final streamingAccount =
            await StreamingAccountStoreService.setStreamingAccountForUser(data);
        store.dispatch(
            SetStreamingAccountAction(streamingAccount: streamingAccount));
        store.dispatch(SetAuthorizeNewStreamingAccountStatus(
            status: AuthorizeNewStreamingAccountStatus.success));
      } on Exception catch (_) {
        store.dispatch(SetAuthorizeNewStreamingAccountStatus(
            status: AuthorizeNewStreamingAccountStatus.failureUnknown));
      }

      // TODO: DISPATCH ACTION TO FETCH LATEST LIBRARY FOR USER
    }

    void _onSpotifyAuthFailure(StreamingAuthError error) {
      switch (error.type) {
        case StreamingAuthErrorType.unknown:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus.failureUnknown));
          break;
        case StreamingAuthErrorType.subscriptionRequired:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureSubscriptionRequired));
          break;
        case StreamingAuthErrorType.incompatibleDevicePlatform:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureIncompatibleDevicePlatform));
          break;
        case StreamingAuthErrorType.incompatibleAccount:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureIncompatibleAccount));
          break;
        case StreamingAuthErrorType.deniedByUser:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureIncompatibleAccount));
          break;
      }
    }

    await spotifyAuthManager.authorize(
        _onSpotifyAuthSuccess, _onSpotifyAuthFailure);
  };
}

ThunkAction<AppState> authorizeAppleMusicAction() {
  return (Store<AppState> store) async {
    final appleMusicAuthManager = AppleMusicAuthManager();

    void _onAppleMusicAuthSuccess(String accessToken) async {
      final data = {
        'accountType': "appleMusic",
        'appleMusicAccessToken': accessToken,
      };

      try {
        final streamingAccount =
            await StreamingAccountStoreService.setStreamingAccountForUser(data);
        store.dispatch(
            SetStreamingAccountAction(streamingAccount: streamingAccount));
        store.dispatch(SetAuthorizeNewStreamingAccountStatus(
            status: AuthorizeNewStreamingAccountStatus.success));
      } on Exception catch (_) {
        store.dispatch(SetAuthorizeNewStreamingAccountStatus(
            status: AuthorizeNewStreamingAccountStatus.failureUnknown));
      }

      // TODO: DISPATCH ACTION TO FETCH LATEST LIBRARY FOR USER
    }

    void _onAppleMusicAuthFailure(StreamingAuthError error) {
      switch (error.type) {
        case StreamingAuthErrorType.unknown:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus.failureUnknown));
          break;
        case StreamingAuthErrorType.subscriptionRequired:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureSubscriptionRequired));
          break;
        case StreamingAuthErrorType.incompatibleDevicePlatform:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureIncompatibleDevicePlatform));
          break;
        case StreamingAuthErrorType.incompatibleAccount:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureIncompatibleAccount));
          break;
        case StreamingAuthErrorType.deniedByUser:
          store.dispatch(SetAuthorizeNewStreamingAccountStatus(
              status: AuthorizeNewStreamingAccountStatus
                  .failureIncompatibleAccount));
          break;
      }
    }

    store.dispatch(SetAuthorizeNewStreamingAccountStatus(
        status: AuthorizeNewStreamingAccountStatus.loading));
    await appleMusicAuthManager.authorize(
        _onAppleMusicAuthSuccess, _onAppleMusicAuthFailure);
  };
}

class SetStreamingAccountAction {
  final UserStreamingAccountStoreItem streamingAccount;
  SetStreamingAccountAction({this.streamingAccount});
}

class SetAuthorizeNewStreamingAccountStatus {
  final AuthorizeNewStreamingAccountStatus status;
  SetAuthorizeNewStreamingAccountStatus({this.status});
}
