import UIKit
import Flutter
import GoogleMaps 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Our Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDPgXT-QrgxMzzpB-9619btqeglGvZwrSA")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
