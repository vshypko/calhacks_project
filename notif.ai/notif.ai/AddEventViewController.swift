//
//  LoginViewController.swift
//  notif.ai
//
//  Created by Yahor Yuzefovich on 11/3/18.
//  Copyright © 2018 notif.ai. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class AddEventViewController: UIViewController {
    let locationManager = CLLocationManager()
    var previousView : String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromAddEvents", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventCategories: UITableView!
    @IBOutlet weak var eventLocation: MKMapView!
    
    
    @IBAction func createEvent(_ sender: Any) {
        
        
        var ref: DocumentReference? = nil
        ref = db.collection("events").addDocument(data: [
            "name": eventName.text ?? "",
            "description": eventDescription.text,
            "category": eventCategories.allowsMultipleSelection,
            "location": "LOCATION",
            "time": ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
}

extension AddEventViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}
