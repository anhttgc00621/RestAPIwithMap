//
//  ViewController.swift
//  Matching
//
//  Created by Tran Anh on 7/26/16.
//  Copyright © 2016 Tran Anh. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var regionRadius: Int = 1000
    var addresses = [AddressLocation]()
    var addressURL:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//        self.mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            
            let coord = self.locationManager.location?.coordinate


            let lng = coord!.longitude
            let lat = coord!.latitude
            addressURL = "lat=\(lat)&lng=\(lng)"
            
//            print(coord)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coord!,CLLocationDistance(regionRadius) * 2.0, CLLocationDistance(regionRadius) * 2.0)
            self.mapView.setRegion(coordinateRegion, animated: true)
            
        } else {
            print("Location services are not enabled")
            let alert = UIAlertController(title: "Location Services Disable", message: "Please go to Setting > Privacy >    Location Services > Enable", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
       

    }
    
    override func viewDidAppear(animated: Bool) {
        addDummyData(5000)
        
    }

    func addDummyData(rad: Int) {

        restApiManager.sharedInstance.getRandomLocation(addressURL!,rad: rad, onComletion: { json in
            for (_ ,subJson):(String, JSON) in json {
                let addressLocation = subJson["address"].object as? String
                let locationName = subJson["name"].object as? String
                let discipline = subJson["short_description"].object as? String
                let latitude = subJson["lat"].object as! Float
                let longitude = subJson["lng"].object as! Float
                let coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
                let address = AddressLocation(address: addressLocation!, title: locationName!, discipline: discipline!, coordinate: coordinate)
                              self.mapView.addAnnotation(address)

//                print(json)

            }
        
        })
    }
    
    //zoom map
   
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        

        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)

        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(center,CLLocationDistance(regionRadius) * 2.0, CLLocationDistance(regionRadius) * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    @IBAction func getCurrent(sender: AnyObject) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true

        } else {
            print("Location services are not enabled")
            let alert = UIAlertController(title: "Location Services Disable", message: "Please go to Setting > Privacy >   Location Services > Enable", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        
        }
    }
    @IBAction func getRequestRadius(sender: UISlider) {
        mapView.removeAnnotations(mapView.annotations)
        regionRadius = Int(sender.value)
        self.addDummyData(Int(sender.value))
        radiusLabel.text = "\(Int(sender.value))"
        print("\(Int(sender.value))")
    }
  
    
    
}



