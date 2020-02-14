//
//  InfoPostingViewController.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import UIKit
import CoreLocation

class InfoPostingViewController: UIViewController {

    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var linkTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Add Location"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationTextField.text = ""
        linkTextField.text = ""
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        checkLocation()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkLocation() {
        guard let location = locationTextField.text, !location.isEmpty else {
            self.showAlertFailure(title: "Location field must be filled out", message: "")
            return
        }
        
        guard let link = linkTextField.text, !link.isEmpty else {
            self.showAlertFailure(title: "Link field must be filled out", message: "")
            return
        }
        
        CLGeocoder().geocodeAddressString(location) { (CLPlace, error) in
            if let place = CLPlace {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard (name: "Main", bundle: nil)
                    let locationVC = storyboard.instantiateViewController(identifier: "LocationViewController") as! LocationViewController
                    locationVC.location = place[0]
                    locationVC.link = link
                    self.navigationController?.pushViewController(locationVC, animated: true)
                }
            } else {
                self.showAlertFailure(title: "Failed Location", message: "Could not retrieve the location specified, please, check and try again")
            }
        }
    }
}
