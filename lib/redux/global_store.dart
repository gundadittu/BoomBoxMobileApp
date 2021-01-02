import 'app/app_reducer.dart';
import 'app/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final globalStore = Store<AppState>(appReducer,
    initialState: new AppState.initial(), middleware: [thunkMiddleware]);
