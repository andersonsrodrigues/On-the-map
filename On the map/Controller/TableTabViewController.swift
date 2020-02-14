//
//  TableTabViewController.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import UIKit

private let reuseNotificationIdentifier = "reloadTable"

class TableTabViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var activity: LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "On the Map"
        if let view = tabBarController?.view {
            activity = LoadingView(view: view)
            requestStudentLocation()
        }
        
        subscribeToReloadTableNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        unsubscribeReloadTableNotifications()
    }
    
    @IBAction func refreshBarButton(_ sender: Any) {
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
                self.showAlertFailure(title: "Failed List Locations", message: error.localizedDescription)
                return
            }
            
            LocationModel.informations = locations
            self.tableView.reloadData()
        }
    }
    
    @objc func reloadTableFromNotification(_ notification: Notification) {
        self.tableView.reloadData()
    }
    
    // MARK: Table - Notifications
    func subscribeToReloadTableNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableFromNotification), name: NSNotification.Name(rawValue: reuseNotificationIdentifier), object: nil)
    }
    
    func unsubscribeReloadTableNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: reuseNotificationIdentifier), object: nil)
    }
}

extension TableTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationModel.informations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tableCell")
        let student = LocationModel.informations[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = LocationModel.informations[indexPath.row]
        if let url = URL(string: student.mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
