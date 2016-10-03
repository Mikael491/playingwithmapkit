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
        
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.78494283, longitude: -122.39712273)
        let region = CLCircularRegion(center: coordinates, radius: 1000, identifier: "Folsem Office")
        self.mapView.add(MKCircle(center: coordinates, radius: 500))
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
    }
    
    //TODO: Display circle over lay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let renderer = MKOverlayRenderer.init(overlay: circle)
            return renderer
        }
        return MKOverlayRenderer()
    }

    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Welcome!", message: "You made it to the office :), please have breakfast on us!", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alert = UIAlertController(title: "Goodbye!", message: "We will see you later!", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //delegate method that fires when user location is recieved
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        self.location = userLocation.location

        //zoom in on user
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
//        print(location)
    
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
    
    //TODO: Directions to Gym
    
    
    
    //TODO: Handle annotations with custom views

}

