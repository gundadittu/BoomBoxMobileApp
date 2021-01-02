import 'package:BoomBoxApp/redux/appResources/app_resources_reducer.dart';

import 'app_state.dart';
import '../auth/auth_reducer.dart';
import '../streaming_auth/streaming_auth_reducer.dart';

AppState appReducer(AppState state, dynamic action) => new AppState(
      appResourcesState: appResourcesReducer(state.appResourcesState, action),
      authState: authReducer(state.authState, action),
      streamingAuthState:
          streamingAuthReducer(state.streamingAuthState, action),
    );
