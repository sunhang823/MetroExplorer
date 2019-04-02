//
//  LandmarksTableViewController.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/16/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//

import UIKit
import MBProgressHUD


class LandmarksTableViewController: UITableViewController{
    var flag = ""
    var station = [Stations]()
    var landmarks = [Businesses](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == "selectMetro" || flag == "nearest" {
            let yelpFusionAPIManager = YelpFusionAPIManager()
            yelpFusionAPIManager.delegate = self
            MBProgressHUD.showAdded(to: self.view, animated: true)
            yelpFusionAPIManager.fetchMetroStations(station: station[0])
        }
        if flag == "favorite"{
            landmarks = PersistenceManager.sharedInstance.fetchLandmarks()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if landmarks.count < 10 {
            return landmarks.count
        }
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "landmarkCell", for: indexPath) as! LandmarkTableViewCell
        let landmark = landmarks[indexPath.row]
        cell.LandmarkName.text = landmark.name
        cell.LandmarkAddress.text = landmark.location.displayAddress[0]        
        if let urlString = landmark.imageUrl, let url = URL(string: urlString) {
            cell.LandmarkImage.load(url: url)
        }        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "landmarkDetailSegue", sender: indexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let row = sender as! Int
        let vc = segue.destination as! LandmarkDetailViewController
        vc.landmark.append(landmarks[row])
    }
}

extension LandmarksTableViewController: FetchLandmarksDelegate{
    func landmarksFound(_ landmarks: [Businesses]) {
        print("Landmarks found - here they are in the controllers!")
        print(landmarks.count)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.landmarks = landmarks
        }
    }
    
    func landmarksNotFound() {
        print("Landmarks not found")
    }
}


