//
//  YelpFusionAPIManager.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/23/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//

import Foundation


protocol FetchLandmarksDelegate {
    func landmarksFound(_ landmarks: [Businesses])
    func landmarksNotFound()
}

class YelpFusionAPIManager {
    var delegate: FetchLandmarksDelegate?
    func fetchMetroStations(station: Stations) {
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")!
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: "restaurant"),
            URLQueryItem(name: "latitude", value: String(station.Lat)),
            URLQueryItem(name: "longitude", value: String(station.Lon))
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("Bearer NgzKbXGYd0FILrbB_88_XOLqHMQ4W1XFJpoAb0GNjDBg8cYCE_WXPwL_oyi2ogZO_ocEnTnaOzBZ5s1hhm2Sp2_y-HE5HxQ7Z1Po-3Jxfam5By6Qts4UtAEy8Rz3W3Yx", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
                
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("request complete")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response is nil or not 200")
                self.delegate?.landmarksNotFound()
                return
            }
            
            guard let data = data else {
                print("data is nil")
                self.delegate?.landmarksNotFound()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let yelpFusionResponse = try decoder.decode(YelpFusionResponse.self, from: data)
                let businesses = yelpFusionResponse.businesses
                self.delegate?.landmarksFound(businesses)
            } catch let error {
                print("codable failed - bad data format")
                print(error.localizedDescription)
                self.delegate?.landmarksNotFound()
            }
        }
        print("execute request")
        task.resume()
    }
}
