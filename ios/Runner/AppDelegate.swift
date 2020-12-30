import UIKit
import Flutter
import StoreKit
import MediaPlayer

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate  {
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        
        return true
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let _ = self.appRemote.connectionParameters.accessToken {
            self.appRemote.connect() // TODO: call flutter telling it this happened
        }
    }
    
    override func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if self.appRemote.isConnected {
            self.appRemote.disconnect() // TODO: Call flutter telling it this happened
        }
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Relevant Docs: https://flutter.dev/docs/development/platform-integration/platform-channels
    
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let spotifyChannel = FlutterMethodChannel(name: "streaming.boombox.app/spotify", binaryMessenger: controller.binaryMessenger);
        spotifyChannel.setMethodCallHandler({[weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "initiateSpotifySession" {
                self?.initiateSpotifySession(result: result);
            }
        });
        
        let appleMusicChannel = FlutterMethodChannel(name: "streaming.boombox.app/apple-music",binaryMessenger: controller.binaryMessenger);
        appleMusicChannel.setMethodCallHandler({[weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            if call.method == "requestAppleMusicUserToken" {
                self?.requestAppleMusicUserToken(result: result)
            } else if call.method == "requestAppleMusicStorefrontCountryCode" {
                self?.requestAppleMusicStorefrontCountryCode(result: result)
            } else if call.method == "requestAppleMusicAuthorization" {
                self?.requestAppleMusicAuthorization(result: result)
            } else if call.method == "requestAppleMusicCapabilities" {
                self?.requestAppleMusicCapabilities(result: result)
            } else if call.method == "playAppleMusicTest" {
                guard let args = call.arguments as? [AnyObject], let songList = args[0] as? [String] else {
                    result(false)
                    return
                }
                self?.playAppleMusicTest(list: songList, result: result)
            } else if call.method == "isUserAuthorizedWithAppleMusic" {
                self?.isUserAuthorizedWithAppleMusic(result: result);
            }
            
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Spotify Session Delegate methods
    
    // TODO: store these credentials in separate file
    let SpotifyClientID = "c9632b686dac475196925c644853531e";
    let SpotifyRedirectURL = URL(string: "boombox-spotify-login://callback")!
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://us-central1-boombox-2b90e.cloudfunctions.net/spotifyTokenSwap"),
           let tokenRefreshURL = URL(string: "https://us-central1-boombox-2b90e.cloudfunctions.net/spotifyRefreshTokenSwap") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        let accessToken = session.accessToken
        self.appRemote.connectionParameters.accessToken = accessToken // TODO: send this back to flutter
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let spotifyCallbackChannel = FlutterMethodChannel(name: "spotifyAuthCallbacks", binaryMessenger: controller.binaryMessenger);
        
        
        spotifyCallbackChannel.invokeMethod("didInitiateSession", arguments: ["accessToken": accessToken])
        
        
        //        self.appRemote.connect() // TODO: make this its own function that flutter can call
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let spotifyCallbackChannel = FlutterMethodChannel(name: "spotifyAuthCallbacks", binaryMessenger: controller.binaryMessenger);
        
        
        spotifyCallbackChannel.invokeMethod("didInitiateSession", arguments: ["errorMessage": error.localizedDescription])
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print(session) // TODO: log this by sending it back to flutter
        
    }
    
    func sessionManager(manager: SPTSessionManager, shouldRequestAccessTokenWith code: String) -> Bool {
        return true
    }
    
    // Spotify App Remote Delegate methods
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("connected")
        
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                // TODO: call flutter player here indicating there was an error
                debugPrint(error.localizedDescription)
            }
        })
        
        // Want to play a new track?
        // self.appRemote.playerAPI?.play("spotify:track:13WO20hoD72L0J13WTQWlT", callback: { (result, error) in
        //     if let error = error {
        //         print(error.localizedDescription)
        //     }
        // })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected appRemote") // TODO: send this back to flutter player + auth?
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed appRemote") // TODO: send this back to flutter spotify player + auth?
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        print("isPaused", playerState.isPaused)
        print("track.uri", playerState.track.uri)
        print("track.name", playerState.track.name)
        print("track.imageIdentifier", playerState.track.imageIdentifier)
        print("track.artist.name", playerState.track.artist.name)
        print("track.album.name", playerState.track.album.name)
        print("track.isSaved", playerState.track.isSaved)
        print("playbackSpeed", playerState.playbackSpeed)
        print("playbackOptions.isShuffling", playerState.playbackOptions.isShuffling)
        print("playbackOptions.repeatMode", playerState.playbackOptions.repeatMode.hashValue)
        print("playbackPosition", playerState.playbackPosition)
        // TODO:  send all this back to flutter spotify player
    }
    
//    Spotify Flutter method handles
    
    private func initiateSpotifySession(result: FlutterResult) {
        if #available(iOS 11.0, *) {
            let requestedScopes: SPTScope = [.appRemoteControl, .streaming, .userFollowRead, .userLibraryRead, .playlistReadCollaborative, .playlistReadPrivate, .userReadRecentlyPlayed, .userReadPrivate, .userTopRead, .userReadPlaybackState, .userModifyPlaybackState];
            self.sessionManager.alwaysShowAuthorizationDialog = false; 
            self.sessionManager.initiateSession(with: requestedScopes, options: .default)
            result(true)
            return
        }
        result(false);
    }
    
    
    // Apple Music Flutter method handlers
    
    private func playAppleMusicTest(list: Array<String>, result: FlutterResult) {
        if #available(iOS 10.3, *) {
            let player = MPMusicPlayerController.applicationQueuePlayer
            let queue  = MPMusicPlayerStoreQueueDescriptor(storeIDs: list)
            player.setQueue(with: queue)
            player.play()
            result("true")
        } else {
            result("old ios error")
        }
    }
    
    private func isUserAuthorizedWithAppleMusic(result: @escaping FlutterResult) {
        if #available(iOS 9.3, *) {
            // authorization is an enum with int values: https://developer.apple.com/documentation/storekit/skcloudserviceauthorizationstatus
            result(SKCloudServiceController.authorizationStatus().rawValue)
        } else {
            // Fallback on earlier versions
            result(false);
        }
    }
    
    private func requestAppleMusicUserToken(result: @escaping FlutterResult) {
        if #available(iOS 11.0, *) {
            // TODO: store developerToken in more secure manner
            let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ikg5N1gyNDRXRzQifQ.eyJpc3MiOiJKUTRLOEVFNzdQIiwiaWF0IjoxNjA4NDAwODA3LCJleHAiOjE2MjIzMDc2MDd9.vNFIr68DREmo6TpIpjExAnsXD8fLW0fW_QdWUPxuGTloKCrSIsBXzmIRCoaoAzRNPhkTi258l-pKg5VmCFqNbw"
            let controller = SKCloudServiceController()
            controller.requestUserToken(forDeveloperToken: developerToken) { (userToken, error) in
                if let _ = error {
                    result(nil)
                } else if let userToken = userToken {
                    result(userToken)
                } else {
                    result(nil)
                }
            }
        } else {
            // Fallback on earlier versions
            // TODO: return appropriate error?
            result(nil)
        }
    }
    
    private func requestAppleMusicStorefrontCountryCode(result: @escaping FlutterResult) {
        if #available(iOS 11.0, *) {
            let controller = SKCloudServiceController()
            controller.requestStorefrontCountryCode { (countryCode, error) in
                if let countryCode = countryCode {
                    result(countryCode)
                } else {
                    result(nil)
                }
            }
        } else {
            // iOS is too old
            result(nil)
        }
    }
    
    private func requestAppleMusicAuthorization(result: @escaping FlutterResult) {
        if #available(iOS 11.0, *) {
            SKCloudServiceController.requestAuthorization { (status) in
                result(status.rawValue)
            }
        } else {
            // iOS too old
            result(2)
        }
    }
    
    private func requestAppleMusicCapabilities(result: @escaping FlutterResult) {
        if #available(iOS 11.0, *) {
            let controller = SKCloudServiceController()
            controller.requestCapabilities { (capabilities, error) in
                let capability_list: [Bool] = [
                    capabilities.contains(.musicCatalogPlayback),
                    capabilities.contains(.musicCatalogSubscriptionEligible),
                    capabilities.contains(.addToCloudMusicLibrary),
                ]
                result(capability_list)
            }
        } else {
            // iOS too old
            result([false, false, false])
        }
    }
    
}
