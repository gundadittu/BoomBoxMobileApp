import 'package:BoomBoxApp/redux/appResources/app_resources_actions.dart';
import 'package:BoomBoxApp/redux/appResources/app_resources_state.dart';
import 'package:redux/redux.dart';

final Reducer<AppResourcesState> appResourcesReducer = combineReducers<AppResourcesState>([
  new TypedReducer<AppResourcesState, SetAppResourceLoadingStatus>(setAppResourceLoadingStatus),
]);

AppResourcesState setAppResourceLoadingStatus(AppResourcesState state, SetAppResourceLoadingStatus action) {
    print("setAppResourceLoadingStatus reducer");
  return state.copyWith(isLoading: action.isLoading); 
}
