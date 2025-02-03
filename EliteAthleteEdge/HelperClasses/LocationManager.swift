//
//  LocationManager.swift
//  repdioUser
//
//  Created by asim on 01/07/2024.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(location: LocationModel?)
   
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationServicesDeniedAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unhandled case for location authorization status.")
        }
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
   
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.stopUpdatingLocation()
              fetchCityAndCountry(from: location) { city, country, error in
                  guard let city = city, let country = country, error == nil else { return }
                  var locatonData = LocationModel()
                  locatonData.city = city
                  locatonData.country = country
                  locatonData.lat = location.coordinate.latitude
                  locatonData.long = location.coordinate.longitude
                  self.delegate?.didUpdateLocation(location: locatonData)
              }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    private func showLocationServicesDeniedAlert() {
        guard let topController = UIApplication.shared.topViewController() else {
            return
        }
        let alertController = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services in Settings.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        topController.present(alertController, animated: true, completion: nil)
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> Void) {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                completion(placemarks?.first?.locality,
                           placemarks?.first?.country,
                           error)
            }
        }
}

struct LocationModel {
    var city: String?
    var country: String?
    var lat: Double?
    var long: Double?
}
