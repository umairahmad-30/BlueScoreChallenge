//
//  WalkThroughViewModel.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 22/08/23.
//

import Foundation
import CoreLocation
import UserNotifications

class WalkthroughViewModel: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
        
    private var locationPermissionCompletion: ((Bool) -> Void)?
    
    var permissions: [Permission] = [
        Permission(type: .location, isGranted: false),
        Permission(type: .notification, isGranted: false)
    ]
    
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationPermissionCompletion = completion
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default:
            locationPermissionCompletion?(false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        CommonUtils.userLocation = location
        
        locationManager.stopUpdatingLocation()
        
        locationPermissionCompletion?(true)
        locationPermissionCompletion = nil
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.delegate = nil
            locationManager.startUpdatingLocation()
        }
    }
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else {
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
}
