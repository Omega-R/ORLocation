//
//  ORCurrentLocationDetector.swift
//  Pods
//
//  Created by Maxim Soloviev on 15/07/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import CoreLocation

public typealias ORCurrentLocationDetectorCompletion = (_ location: CLLocation?) -> Void

@objc open class ORCurrentLocationDetector: NSObject, CLLocationManagerDelegate {
    
    fileprivate lazy var locationManager = CLLocationManager()
    
    fileprivate var maxTimeToWaitDetection: TimeInterval?
    fileprivate var completion: ORCurrentLocationDetectorCompletion?
    
    fileprivate var detectionAwaitingTimer: Timer?

    @objc public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    @objc open func detect(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters, maxTimeToWaitDetection: TimeInterval = TimeInterval.infinity, completion: @escaping ORCurrentLocationDetectorCompletion) {
        self.maxTimeToWaitDetection = maxTimeToWaitDetection != TimeInterval.infinity ? maxTimeToWaitDetection : nil
        self.completion = completion
        
        locationManager.desiredAccuracy = desiredAccuracy

        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            onFail()
            return
        default:
            break
        }
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func onFail() {
        callCompletion(nil)
    }

    fileprivate func callCompletion(_ location: CLLocation?) {
        locationManager.stopUpdatingLocation()
        completion?(location)
        completion = nil
    }

    fileprivate func startTimerIfNeeded() {
        if let interval = maxTimeToWaitDetection , detectionAwaitingTimer == nil {
            detectionAwaitingTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(callCompletionByTimer), userInfo: nil, repeats: false)
        }
    }
    
    @objc fileprivate func callCompletionByTimer() {
        detectionAwaitingTimer?.invalidate()
        detectionAwaitingTimer = nil
        onFail()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("CLLocationManager status: \(status.rawValue)")
        switch status {
        case .restricted, .denied:
            onFail()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            startTimerIfNeeded()
            return
        default:
            break
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("CLLocationManager error:\n \(error.description)")
        
        guard let clErr = CLError.Code(rawValue: error._code) , clErr == .locationUnknown else {
            // do nothing
            return
        }
        
        onFail()
    }
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
//        print("CLLocationManager location: \(location)")
        callCompletion(location)
    }
}
