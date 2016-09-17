//
//  ORCurrentLocationDetector.swift
//  Pods
//
//  Created by Maxim Soloviev on 15/07/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import CoreLocation

public typealias ORCurrentLocationDetectorCompletion = (location: CLLocation?) -> Void

@objc public class ORCurrentLocationDetector: NSObject, CLLocationManagerDelegate {
    
    private lazy var locationManager = CLLocationManager()
    
    private var maxTimeToWaitDetection: NSTimeInterval?
    private var completion: ORCurrentLocationDetectorCompletion?
    
    private var detectionAwaitingTimer: NSTimer?

    @objc public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    @objc public func detect(desiredAccuracy desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters, maxTimeToWaitDetection: NSTimeInterval = NSTimeInterval.infinity, completion: ORCurrentLocationDetectorCompletion) {
        self.maxTimeToWaitDetection = maxTimeToWaitDetection != NSTimeInterval.infinity ? maxTimeToWaitDetection : nil
        self.completion = completion
        
        locationManager.desiredAccuracy = desiredAccuracy

        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied:
            onFail()
            return
        default:
            break
        }
        locationManager.startUpdatingLocation()
    }
    
    private func onFail() {
        callCompletion(nil)
    }

    private func callCompletion(location: CLLocation?) {
        locationManager.stopUpdatingLocation()
        completion?(location: location)
        completion = nil
    }

    private func startTimerIfNeeded() {
        if let interval = maxTimeToWaitDetection where detectionAwaitingTimer == nil {
            detectionAwaitingTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(callCompletionByTimer), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func callCompletionByTimer() {
        detectionAwaitingTimer?.invalidate()
        detectionAwaitingTimer = nil
        onFail()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        print("CLLocationManager status: \(status.rawValue)")
        switch status {
        case .Restricted, .Denied:
            onFail()
            return
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            startTimerIfNeeded()
            return
        default:
            break
        }
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("CLLocationManager error:\n \(error.description)")
        
        guard let clErr = CLError(rawValue: error.code) where clErr == .LocationUnknown else {
            // do nothing
            return
        }
        
        onFail()
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
//        print("CLLocationManager location: \(location)")
        callCompletion(location)
    }
}
