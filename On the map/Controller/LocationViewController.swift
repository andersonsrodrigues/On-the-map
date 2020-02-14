//
//  LocationViewController.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var location: CLPlacemark?
    var link: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Location"
        parseLocation()
    }

    @IBAction func submitButton(_ sender: Any) {
        if let placemark = location {
            if let locationArea = placemark.locality, let subLocationArea = placemark.administrativeArea, let country = placemark.country, let location = placemark.location, let studentLink = link {
                OTMClient.createStudentLocation(address: "\(locationArea) - \(subLocationArea), \(country)", link: studentLink, lat: location.coordinate.latitude, long: location.coordinate.longitude, completion: handleCreateStudentLocationResponse(success:error:))
            }
        }
    }
    
    func handleCreateStudentLocationResponse(success: Bool, error: Error?) {
        if success {
            
            self.dismiss(animated: true, completion: nil)
        } else {
            print(error)
            showAlertFailure(title: "Failed Location", message: error?.localizedDescription ?? "")
        }
    }
    
    func parseLocation() {
        if let location = location {
            let placemark = MKPlacemark(placemark: location)
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            
            self.mapView.addAnnotation(placemark)
            self.mapView.selectAnnotation(placemark, animated: true)
            self.mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate

extension LocationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
