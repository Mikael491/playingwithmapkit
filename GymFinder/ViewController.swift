//
//  ViewController.swift
//  GymFinder
//
//  Created by Mikael Teklehaimanot on 10/2/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        setup()
        
        //on tap creates annotation with reverse geocoded address
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.addAnnotation))
        mapView.addGestureRecognizer(tapGesture)
        
        
    }

    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    //delegate method that fires when user location is recieved
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        self.location = userLocation.location
        
        //zoom in on user
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
        
    }
    
    //method that reverse geocodes address asynchronously and creates annotation with that address synchronously
    func addAnnotation() {
        
        self.geoCoder.reverseGeocodeLocation(self.location!) { (location, error) in
            
            guard let addressPieces = location?[0].addressDictionary else {
                print("Error grabbing address from location - \(location?[0].addressDictionary)")
                return
            }
            
            guard let street = addressPieces["Street"] as? String else {
                print("Error grabbing street address from - \(addressPieces)")
                return
            }
            
            DispatchQueue.global().sync {
                let annotation = Annotation(coordinate: (self.location?.coordinate)!, title: street, subtitle: "Annotation Subtitle")
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    //TODO: Handle annotations with custom views

}

