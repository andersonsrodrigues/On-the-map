//
//  MapTabViewController.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import UIKit
import MapKit

class MapTabViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "On the Map"
        requestStudentLocation()
    }
    
    @IBAction func refreshBarButton(_ sender: Any) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        requestStudentLocation()
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        let infoPostingVC = storyboard?.instantiateViewController(identifier: "infoPostingVC") as! UINavigationController
        self.present(infoPostingVC, animated: true, completion: nil)
    }
    
    func requestStudentLocation() {
        OTMClient.getStudentLocation(query: "limit=100&order=-updatedAt") { (locations, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            LocationModel.informations = locations
            self.parseLocations()
        }
    }
    
    func parseLocations() {
        var annotations = [MKPointAnnotation]()
            
        for local in LocationModel.informations {
            let lat = CLLocationDegrees(local.latitude)
            let long = CLLocationDegrees(local.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(local.firstName) \(local.lastName)"
            annotation.subtitle = local.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func handleCheckStudentLocationResponse(sucess: Bool, error: Error?) {
        if sucess {
            let alertVC = UIAlertController(title: "Student Location", message: "You have already posted a Student Location. Would you like to overwrite your current location?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                print(action)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
//            let infoPostingVC = storyboard?.instantiateViewController(identifier: "infoPostingVC") as! InfoPostingViewController
//            self.present(infoPostingVC, animated: true, completion: nil)
        } else {
            showAlertFailure(title: "Failed Check Student Location", message: error?.localizedDescription ?? "")
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapTabViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}