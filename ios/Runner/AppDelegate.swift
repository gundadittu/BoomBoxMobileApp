import UIKit
import Flutter
import StoreKit
import MediaPlayer

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Relevant Docs: https://flutter.dev/docs/development/platform-integration/platform-channels
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
   
    let appleMusicChannel = FlutterMethodChannel(name: "streaming.boombox.app/apple-music",binaryMessenger: controller.binaryMessenger)
    
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
                if let error = error {
                    result(error.localizedDescription)
                } else if let userToken = userToken {
                    result(userToken)
                } else {
                    result("no user token")
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
            result(0)
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
