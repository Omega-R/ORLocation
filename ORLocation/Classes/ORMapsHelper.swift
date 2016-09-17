//
//  ORMapsHelper.swift
//  Pods
//
//  Created by Maxim Soloviev on 20/06/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import Foundation
import MapKit

public typealias ORGeoSearchResponseBlock = (items: [MKMapItem]?, error: NSError?) -> Void

@objc public class ORMapsHelper: NSObject {
    
    public static func mapItemWithCoordinate(coordinate: CLLocationCoordinate2D, addressInfo info:[String: String]?) -> MKMapItem {
        let mark = MKPlacemark(coordinate: coordinate, addressDictionary: info)
        return MKMapItem(placemark: mark)
    }
    
    public static func mapItemsForAddress(address: String, completion: ORGeoSearchResponseBlock) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            guard let array = placemarks else {
                completion(items: nil, error: error)
                return
            }
            
            var items = [MKMapItem]()
            
            for mark in array {
                if let addressDict = mark.addressDictionary as? [String:AnyObject]?, coordinate = mark.location?.coordinate {
                    let mkPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
                    items.append(MKMapItem(placemark: mkPlacemark))
                }
            }
            completion(items: items, error: error)
        })
    }
}
