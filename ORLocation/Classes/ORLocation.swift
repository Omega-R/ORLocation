//
//  ORLocation.swift
//  ORLocation
//
//  Created by Maxim Soloviev on 30/09/2017.
//

import Foundation
import CoreLocation

open class ORLocation: NSObject, CLLocationManagerDelegate {
    
    public static let shared = ORLocation()
    
    var locationManager: CLLocationManager!
    
    open func requestAuthorizationIfNeeded() {
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            return
        default:
            locationManager = nil
        }
    }
}
