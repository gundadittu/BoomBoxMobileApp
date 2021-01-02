import 'package:BoomBoxApp/redux/app/app_state.dart';
import 'package:BoomBoxApp/redux/appResources/app_resources_actions.dart';
import 'package:BoomBoxApp/routes.dart';
import 'package:BoomBoxApp/screens/auth_screen/auth_screen.dart';
import 'package:BoomBoxApp/screens/main_bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'global_navigator.dart';
import 'package:redux/redux.dart';

import 'redux/global_store.dart';

Future<void> main() async {
  //  WidgetsFlutterBinding.ensureInitialized(); added due to address the issue discussed here:
  // - https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init(
    (options) => options.dsn =
        'https://55e8c725858d460588bc683e69ebb554@o493644.ingest.sentry.io/5563418', // TODO: refactor to store dsn in config file
    appRunner: () => runApp(MyApp(
      store: globalStore,
    )),
  );
}

class MyApp extends StatefulWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: this.widget.store,
      child: MaterialApp(
          title: 'BoomBox', // TODO: refactor to global config file
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.yellowAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // Initializes Firebase SDK and UI
          // home: _firebaseAndProvidersBuilder(),
          navigatorObservers: [
            SentryNavigatorObserver(),
          ],
          navigatorKey: GlobalNavigator.key,
          home: AppLoadingScreen(),
          routes: {
            Routes.signInScreen: (_) => AuthScreen(),
            Routes.mainBottomNavBarScreen: (_) => MainBottomNavBarScreen(),
          }),
    );
  }
}

class AppLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      onInit: (store) {
        store.dispatch(initAppResources());
      },
      converter: (store) => store.state,
      builder: (context, state) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

// // Flutter + Dart dependencies
// import 'package:flutter/material.dart';
// // import 'package:flutter/foundation.dart';

// // External dependencies
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

// // Providers
// import 'providers/auth_manager.dart';
// import 'providers/streaming_auth_manager.dart';
// import 'package:BoomBoxApp/providers/streaming_library_manager.dart';

// // Screens
// import 'screens/auth_screen.dart';
// import 'package:BoomBoxApp/screens/home_screen.dart';

// // Internal Helpers
// import './error_manager.dart';
// import './firebase_manager.dart';

// // Note: Ignore the below error when executing "flutter run" for Android. Not fatal. Will be fixed in future Android release.
// // - W/ConnectionTracker(18335): Exception thrown while unbinding
// // - W/ConnectionTracker(18335): java.lang.IllegalArgumentException: Service not registered: lu@7e72165
// // - ..........
// // Refer to the below links for more info:
// // https://github.com/firebase/firebase-android-sdk/issues/2244
// // https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in

// Future<void> main() async {
//   //  WidgetsFlutterBinding.ensureInitialized(); added due to address the issue discussed here:
//   // - https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
//   WidgetsFlutterBinding.ensureInitialized();
//   await SentryFlutter.init(
//     (options) => options.dsn =
//         'https://55e8c725858d460588bc683e69ebb554@o493644.ingest.sentry.io/5563418', // TODO: refactor to store dsn in config file
//     appRunner: () => runApp(MyApp()),
//   );
// }

// class MyApp extends StatelessWidget {
//   /*
//   Relevant docs:
//   - FlutterFire: https://firebase.flutter.dev/docs/overview
//   - How to setup
//   */
//   // FutureBuilder _firebaseAndProvidersBuilder() {
//   //   Future<FirebaseApp> _firebaseInitialization() async {
//   //     try {
//   //       FirebaseApp firebase = await Firebase.initializeApp();
//   //       FirebaseManager.shared = firebase;
//   //       return firebase;
//   //     } catch (error, stackTrace) {
//   //       ErrorManager.reportError(error, stackTrace);
//   //       throw error;
//   //     }
//   //   }

//   //   return FutureBuilder(
//   //     // Initialize FlutterFire:
//   //     future: _firebaseInitialization(),
//   //     builder: (context, snapshot) {
//   //       // Firebase SDK initialization success
//   //       if (snapshot.connectionState == ConnectionState.done) {
//   //         return MultiProvider(
//   //           providers: [
//   //             ChangeNotifierProvider(
//   //               lazy: false,
//   //               create: (_) => AuthManager(),
//   //             ),
//   //             ChangeNotifierProxyProvider<AuthManager, StreamingAuthManager>(
//   //               lazy: false,
//   //               create: (context) => StreamingAuthManager()
//   //                 ..update(
//   //                     Provider.of<AuthManager>(context, listen: false).userUid),
//   //               update: (context, authManager, streamingAuthManager) {
//   //                 return streamingAuthManager..update(authManager.userUid);
//   //               },
//   //             ),
//   //             ChangeNotifierProxyProvider2<AuthManager, StreamingAuthManager,
//   //                     StreamingLibraryManager>(
//   //                 lazy: false,
//   //                 create: (context) {
//   //                   return StreamingLibraryManager()
//   //                     ..update(
//   //                       Provider.of<AuthManager>(context, listen: false)
//   //                           .userUid,
//   //                       Provider.of<StreamingAuthManager>(context,
//   //                               listen: false)
//   //                           .streamingAccount,
//   //                     );
//   //                 },
//   //                 update: (context, authManager, streamingAuthManager,
//   //                     streamingLibraryManager) {
//   //                   return streamingLibraryManager
//   //                     ..update(authManager.userUid,
//   //                         streamingAuthManager.streamingAccount);
//   //                 }),
//   //           ],
//   //           child: HomeScreen(),
//   //         );
//   //       }

//   //       // Firebase SDK initialization failed
//   //       if (snapshot.hasError) {
//   //         return Text(
//   //             "Something went wrong"); // TODO: Create proper page for this
//   //       }

//   //       // Firebase SDK initialization in progress
//   //       return Text("Loading"); // TODO: Replace this with proper page
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'BoomBox', // TODO: refactor to global config file
//         theme: ThemeData(
//           primarySwatch: Colors.purple,
//           accentColor: Colors.yellowAccent,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         // Initializes Firebase SDK and UI
//         home: _firebaseAndProvidersBuilder(),
//         navigatorObservers: [
//           SentryNavigatorObserver(),
//         ],
//         routes: {
//           AuthScreen.routeName: (_) => AuthScreen(),
//         });
//   }
// }
