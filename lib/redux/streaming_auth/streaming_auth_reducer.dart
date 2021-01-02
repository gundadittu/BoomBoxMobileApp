import 'package:redux/redux.dart';

import 'streaming_auth_actions.dart';
import 'streaming_auth_state.dart';

final streamingAuthReducer = combineReducers<StreamingAuthState>([
  new TypedReducer<StreamingAuthState, SetStreamingAccountAction>(
      setStreamingAccount),
  new TypedReducer<StreamingAuthState, SetAuthorizeNewStreamingAccountStatus>(
      setAuthorizeNewStreamingAccountStatus),
]);

StreamingAuthState setStreamingAccount(
    StreamingAuthState state, SetStreamingAccountAction action) {
  print("setStreamingAccount reducer");
  return state.copyWith(streamingAccount: action.streamingAccount);
}

StreamingAuthState setAuthorizeNewStreamingAccountStatus(
    StreamingAuthState state, SetAuthorizeNewStreamingAccountStatus action) {
  print("setAuthorizeNewStreamingAccountStatus reducer: "+action.status.toString());
  return state.copyWith(authorizeNewStreamingAccountStatus: action.status);
}
