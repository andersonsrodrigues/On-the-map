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
    var activity: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Location"
        parseLocation()
        if let navigation = navigationController?.view {
            activity = LoadingView(view: navigation)
        }
    }

    @IBAction func submitButton(_ sender: Any) {
        if let placemark = location {
            if let locationArea = placemark.locality, let subLocationArea = placemark.administrativeArea, let country = placemark.country, let location = placemark.location, let studentLink = link {
                OTMClient.createStudentLocation(address: "\(locationArea) - \(subLocationArea), \(country)", link: studentLink, lat: location.coordinate.latitude, long: location.coordinate.longitude, completion: handleCreateStudentLocationResponse(success:error:))
            } else {
                self.showAlertFailure(title: "Failed Map Locations", message: "There's some information missing, please, go back and try again")
            }
        } else {
            self.showAlertFailure(title: "Failed Map Locations", message: "Could not find the apropriated location, please, go back and try again")
        }
    }
    
    func handleCreateStudentLocationResponse(success: Bool, error: Error?) {
        if success {
            activity.showActivityView()
            
            OTMClient.getStudentLocation(query: "limit=100&order=-updatedAt") { (locations, error) in
                self.activity.hideActivityView()
                
                if let error = error {
                    self.showAlertFailure(title: "Failed Map Locations", message: error.localizedDescription)
                    return
                }

                LocationModel.informations = locations
                
                NotificationCenter.default.post(name: NSNotification.Name("reloadMap"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("reloadTable"), object: nil)
                
                self.dismiss(animated: true, completion: nil)
            }
        } else {
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
