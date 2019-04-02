//
//  LandmarkDetailViewController.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/30/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//

import UIKit
import MapKit

class LandmarkDetailViewController: UIViewController {
    var landmark = [Businesses]()

    @IBOutlet weak var LandmarkName: UILabel!
    
    @IBOutlet weak var LandmarkImage: UIImageView!
    
    @IBOutlet weak var LandmarkRating: UILabel!
    
    @IBOutlet weak var LandmarkAddress: UILabel!
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let shareText = "Check out this place: \(landmark[0].name)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any){
        let landmarks = PersistenceManager.sharedInstance.fetchLandmarks()
        if isInTheList(landmarks: landmarks, landmark: landmark[0]){
            PersistenceManager.sharedInstance.removeLandmark(landmark: landmark[0])
        }else{
            PersistenceManager.sharedInstance.saveLandmark(landmark: landmark[0])
        }
    }
    
    
    @IBAction func directionButtonPressed(_ sender: Any) {
        print("map")

        
        let latitude:CLLocationDegrees = landmark[0].coordinates.latitude
        let longitude:CLLocationDegrees = landmark[0].coordinates.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = landmark[0].name
        mapItem.openInMaps(launchOptions: options)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LandmarkName.text = landmark[0].name
        LandmarkRating.text = "Rating: " + String(landmark[0].rating)
        LandmarkAddress.text = landmark[0].location.displayAddress[0]
        if let urlString = landmark[0].imageUrl, let url = URL(string: urlString) {
            LandmarkImage.load(url: url)
        }
    }
    
    func isInTheList(landmarks: [Businesses], landmark: Businesses) -> Bool{
        for currentlandmark in landmarks{
            if currentlandmark.id == landmark.id{
                return true
            }
        }
        return false
    }
}
