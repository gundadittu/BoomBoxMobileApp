import 'package:BoomBoxApp/models/user_streaming_account_store_item.dart';
import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:BoomBoxApp/redux/streaming_auth/streaming_auth_actions.dart';
import 'package:BoomBoxApp/redux/streaming_auth/streaming_auth_state.dart';

import 'package:redux/redux.dart';

class StreamingAuthScreenModel {
  final Function authorizeAppleMusic;
  final Function authorizeSpotify; 
  final UserStreamingAccountStoreItem currentStreamingAccount; 
  final AuthorizeNewStreamingAccountStatus authorizeNewStreamingAccountStatus; 

  StreamingAuthScreenModel({
    this.authorizeAppleMusic, 
    this.authorizeSpotify, 
    this.currentStreamingAccount,
    this.authorizeNewStreamingAccountStatus,
  });

  static StreamingAuthScreenModel fromStore(Store<AppState> store) {
    return StreamingAuthScreenModel(
      authorizeAppleMusic: () {
        store.dispatch(authorizeAppleMusicAction());
      },
      authorizeSpotify: () {
        store.dispatch(authorizeSpotifyAction());
      },
      currentStreamingAccount: store.state.streamingAuthState.streamingAccount, 
      authorizeNewStreamingAccountStatus: store.state.streamingAuthState.authorizeNewStreamingAccountStatus
    );
  }
}