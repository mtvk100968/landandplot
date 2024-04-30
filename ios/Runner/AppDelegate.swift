import UIKit
import Flutter
import Firebase // Import Firebase
import GoogleMaps // Import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide your Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc")

    // Configure Firebase
    FirebaseApp.configure()

    // Register plugins
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}