//
//  ORMapsHelper.swift
//  Pods
//
//  Created by Maxim Soloviev on 20/06/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import Foundation
import MapKit

public typealias ORGeoSearchResponseBlock = (_ items: [MKMapItem]?, _ error: Error?) -> Void

@objc open class ORMapsHelper: NSObject {
    
    public static func mapItemWithCoordinate(_ coordinate: CLLocationCoordinate2D, addressInfo info:[String: String]?) -> MKMapItem {
        let mark = MKPlacemark(coordinate: coordinate, addressDictionary: info)
        return MKMapItem(placemark: mark)
    }
    
    public static func mapItemsForAddress(_ address: String, completion: @escaping ORGeoSearchResponseBlock) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let array = placemarks else {
                completion(nil, error)
                return
            }
            
            var items = [MKMapItem]()
            
            for mark in array {
                if let addressDict = mark.addressDictionary as? [String:AnyObject]?, let coordinate = mark.location?.coordinate {
                    let mkPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
                    items.append(MKMapItem(placemark: mkPlacemark))
                }
            }
            completion(items, error)
        }
    }
}
