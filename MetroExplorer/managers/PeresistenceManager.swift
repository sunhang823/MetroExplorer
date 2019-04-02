//
//  PeresistenceManager.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/22/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    static let sharedInstance = PersistenceManager()
    let landmarksKey = "landmarks"
    
    func saveLandmark(landmark: Businesses) {
        let userDefaults = UserDefaults.standard
        var landmarks = fetchLandmarks()
        landmarks.append(landmark)
        let encoder = JSONEncoder()
        let encodedLandmarks = try? encoder.encode(landmarks)
        
        userDefaults.set(encodedLandmarks, forKey: landmarksKey)
    }
    
    func removeLandmark(landmark: Businesses) {
        let userDefaults = UserDefaults.standard
        var landmarks = fetchLandmarks()
        for landmarkIndex in 0..<landmarks.count{
            if landmarks[landmarkIndex].id == landmark.id{
                landmarks.remove(at: landmarkIndex)
            }
        }
        let encoder = JSONEncoder()
        let encodedLandmarks = try? encoder.encode(landmarks)
        userDefaults.set(encodedLandmarks, forKey: landmarksKey)
    }
    
    func fetchLandmarks() -> [Businesses] {
        let userDefaults = UserDefaults.standard
        if let landmarkData = userDefaults.data(forKey: landmarksKey), let landmarks = try? JSONDecoder().decode([Businesses].self, from: landmarkData) {
            return landmarks
        }
        else {
            return [Businesses]()
        }
    }
}
