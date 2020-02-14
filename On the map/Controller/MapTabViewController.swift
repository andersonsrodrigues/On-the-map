//
//  MapTabViewController.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import UIKit
import MapKit

private let reuseNotificationIdentifier = "reloadMap"

class MapTabViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var activity: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "On the Map"
        if let view = tabBarController?.view {
            activity = LoadingView(view: view)
            requestStudentLocation()
        }
        
        subscribeToReloadMapNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        unsubscribeReloadMapNotifications()
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
        activity.showActivityView()
        
        OTMClient.getStudentLocation(query: "limit=100&order=-updatedAt") { (locations, error) in
            self.activity.hideActivityView()
            
            if let error = error {
                self.showAlertFailure(title: "Failed Map Locations", message: error.localizedDescription)
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
    
    @objc func reloadMapFromNotification(_ notification: Notification) {
        parseLocations()
    }
    
    // MARK: Table - Notifications
    func subscribeToReloadMapNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMapFromNotification), name: NSNotification.Name(rawValue: reuseNotificationIdentifier), object: nil)
    }
    
    func unsubscribeReloadMapNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: reuseNotificationIdentifier), object: nil)
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
