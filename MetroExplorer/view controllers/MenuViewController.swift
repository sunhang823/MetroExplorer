//
//  MenuViewController.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/16/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class MenuViewController: UIViewController {
    var locationDetector = LocationDetector()
    var currentLat: Double = 0
    var currentLon: Double = 0
    var stations = [Stations]()
    var selectedStation = [Stations]()
    
    
    @IBAction func NearestButtonPressed(_ sender: Any) {
        print("nearest button pressed")

        let nearestMetroStation = findNearestMetroStation()
        selectedStation.append(nearestMetroStation)
        performSegue(withIdentifier: "nearestLandmarksSegue", sender: self)
    }
    
    @IBAction func SelectStationButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: "metroStationSegue", sender: self)
    }
    
    @IBAction func FavoritesButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: "favoriteLandmarkSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteLandmarkSegue"{
            let vc = segue.destination as! LandmarksTableViewController
            vc.flag = "favorite"
        }
        if segue.identifier == "nearestLandmarksSegue"{
            let vc = segue.destination as! LandmarksTableViewController
            vc.station.append(selectedStation[0])
            vc.flag = "nearest"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        locationDetector.delegate = self
        locationDetector.findLocation()
    }
    
    func showLocationDisabledPopUp(){
        let alertController = UIAlertController(title: "Background location Access Disabled",
                                                message: "In order to find your nearest Metro Station we need your location",
                                                preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        alertController.addAction(cancleAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default){ (action) in
            if let url  = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func findMetroStations() {
        let wmataAPIManager = WmataAPIManager()
        wmataAPIManager.delegate = self
        wmataAPIManager.fetchMetroStations()
    }
    
    func findNearestMetroStation() -> Stations{
        var nearestMetroStation = stations[0]
        var nearestDistance = Double(INT_MAX)
        for station in stations{
            let currentDistance = pow((station.Lat - currentLat), 2) + pow((station.Lon - currentLon), 2)
            if currentDistance < nearestDistance{
                nearestDistance = currentDistance
                nearestMetroStation = station
            }
        }
        return nearestMetroStation
    }
}

extension MenuViewController: FetchMetroStationsDelegate{
    func metroStationsFound(_ metroStations: [Stations]){
        print("Metro Stations found - here they are in the controllers!")
        print(metroStations.count)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.stations = metroStations
        }
    }
    
    func metroStationsNotFound(){
        print("Metro Stations not found")
    }
}


extension MenuViewController: LocationDetectorDelegate {
    func locationDetected(latitude: Double, longitude: Double) {
        currentLat = latitude
        currentLon = longitude
        findMetroStations()
    }
    
    func locationNotDetected() {
        print("no location found :(")
        //showLocationDisabledPopUp()
    }
}

