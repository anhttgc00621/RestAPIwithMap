//
//  AddressLocation.swift
//  Matching
//
//  Created by Tran Anh on 7/26/16.
//  Copyright © 2016 Tran Anh. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class AddressLocation: NSObject, MKAnnotation {
    var address: String?
    let title: String?
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    
    
    
    init(address: String, title: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.address = address
        self.title = title
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
}
    var subtitle: String? {
        return address
    }

    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [String(CNPostalAddressStreetKey): self.subtitle!]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
    
}
