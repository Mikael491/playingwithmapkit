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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        setup()
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("addAnnotation")))
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
    
    func addAnnotation() {
        let annotation = Annotation(coordinate: (self.location?.coordinate)!, title: "Annotation Title", subtitle: "Annotation Subtitle")
        self.mapView.addAnnotation(annotation)
    }

}

