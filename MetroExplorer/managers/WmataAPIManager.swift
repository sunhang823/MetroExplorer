//
//  WmataAPIManager.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/22/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//

import Foundation

protocol FetchMetroStationsDelegate {
    func metroStationsFound(_ metroStations: [Stations])
    func metroStationsNotFound()
}

class WmataAPIManager {
    var delegate: FetchMetroStationsDelegate?
    
    func fetchMetroStations() {
        var urlComponents = URLComponents(string: "https://api.wmata.com/Rail.svc/json/jStations")!
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: "3192891a78a94a1a8e3da81baf65d223")]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("request complete")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response is nil or not 200")
                self.delegate?.metroStationsNotFound()
                return
            }
            
            guard let data = data else {
                print("data is nil")
                self.delegate?.metroStationsNotFound()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let wmataResponse = try decoder.decode(WmataResponse.self, from: data)
                let stations = wmataResponse.Stations
                self.delegate?.metroStationsFound(stations)
            } catch let error {
                print("codable failed - bad data format")
                print(error.localizedDescription)
                self.delegate?.metroStationsNotFound()
            }
        }
        print("execute request")
        task.resume()
    }
}

