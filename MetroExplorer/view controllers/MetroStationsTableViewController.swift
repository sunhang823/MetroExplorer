//
//  MetroStationsTableViewController.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/16/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//



import UIKit
import MBProgressHUD

class MetroStationsTableViewController: UITableViewController {
    
    var stations = [Stations](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wmataAPIManager = WmataAPIManager()
        wmataAPIManager.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        wmataAPIManager.fetchMetroStations()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "metroStationCell", for: indexPath) as! MetroStationTableViewCell
        cell.MetroStationName.text = stations[indexPath.row].Name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "landmarksSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let row = sender as! Int
        let vc = segue.destination as! LandmarksTableViewController
        vc.station.append(stations[row])
        vc.flag = "selectMetro"
    }
}

extension MetroStationsTableViewController: FetchMetroStationsDelegate{
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
