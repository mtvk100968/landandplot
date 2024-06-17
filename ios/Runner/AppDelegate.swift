// import UIKit
// import Flutter
// import Firebase // Import Firebase
// import GoogleMaps // Import GoogleMaps
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     // Provide your Google Maps API Key
//     GMSServices.provideAPIKey("AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc")
//
//     // Configure Firebase
//     FirebaseApp.configure()
//
//     // Register plugins
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import UIKit
import Flutter
import Firebase
import GoogleMaps
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize the LocationManager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()

        // Provide your Google Maps API Key
        GMSServices.provideAPIKey("AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc")

        // Initialize Firebase
        FirebaseApp.configure()

        // Enable verbose logging
        FirebaseConfiguration.shared.setLoggerLevel(.debug)

        // Register plugins
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates
        if let location = locations.first {
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle errors
        print("Failed to get location: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Show an alert asking the user to enable location permissions in settings
            let alertController = UIAlertController(
                title: "Location Permission",
                message: "Please enable location permissions in settings.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}
