// Flutter + Dart dependencies
import 'package:flutter/material.dart';

// External dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Providers
import 'provider/auth_manager.dart';

// Screens
import 'screens/auth_screen.dart'; 

// Note ignore the below error when executing "flutter run" for Android. Not fatal. Will be fixed in future Android release.
// - W/ConnectionTracker(18335): Exception thrown while unbinding
// - W/ConnectionTracker(18335): java.lang.IllegalArgumentException: Service not registered: lu@7e72165
// - ..........
// Refer to the below links for more info:
// https://github.com/firebase/firebase-android-sdk/issues/2244
// https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // MyApp is the application's root widget

  Future<FirebaseApp> _firebaseInitialization() async {
    FirebaseApp firebase = await Firebase.initializeApp();
    return firebase;
  }

  FutureBuilder _createFirebaseFutureBuilder() {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _firebaseInitialization(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong"); // Create proper widget for this
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return HomePage();
        }
        return Text("Loading"); // Replace this with proper page
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoomBox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _createFirebaseFutureBuilder(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  /*
  Notes: 
  - Sets up Firebase deep linking
  - Used to handle authentication by email link 
  Relevant Docs: 
  - https://pub.dev/packages/firebase_dynamic_links 
  - PendingDynamicLinkData: https://pub.dev/documentation/firebase_dynamic_links/latest/firebase_dynamic_links/PendingDynamicLinkData-class.html
  */
  void initDynamicLinks() async {
    // Includes logic to check if deep link is for signing in via email and tell AuthManager
    Future<bool> handleEmailAuthLink(Uri deepLink) async {
      final String deepLinkString = deepLink.toString();
      try {
        if (FirebaseAuth.instance.isSignInWithEmailLink(deepLinkString)) {
          await Provider.of<AuthManager>(context, listen: false).verifyEmailAuthLink(deepLinkString); 
          return true; 
        } else { 
          return false; 
        }
      } catch (error) {
        throw error; // handle error with UI alert, etc.
      }
    }

    // Configures FirebaseDynamicLink onLink listener to handle deep links going forward
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        await handleEmailAuthLink(deepLink); 
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message); // refactor to let UI show error message
    });

    // Checks if a dynamic link opened the app; will retun null otherwise 
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      await handleEmailAuthLink(deepLink); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthManager(),
        ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        //   create: null,
        //   update: (ctx, auth, previousProducts) => Products(
        //     auth.token,
        //     auth.userId,
        //     previousProducts == null ? [] : previousProducts.items,
        //   ),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => Cart(),
        // ),
        // ChangeNotifierProxyProvider<Auth, Orders>(
        //   create: null,
        //   update: (ctx, auth, previousOrders) => Orders(
        //     auth.token,
        //     auth.userId,
        //     previousOrders == null ? [] : previousOrders.orders,
        //   ),
        // ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, _) {
          return authManager.isLoggedIn == true
              ? Text("logged in") // Replace this with proper page
              : AuthScreen(); // Replace with proper page
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
