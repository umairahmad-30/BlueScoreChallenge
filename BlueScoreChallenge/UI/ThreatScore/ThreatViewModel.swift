//
//  ThreatViewModel.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 23/08/23.
//

import Foundation

class ThreatViewModel {
    var bluescore: Double = 0.0
    
    // Simulated threat data
    var threatLocations = [ThreatLocation]()
    
    init() {
        self.threatLocations = generateAdditionalThreatData(baseLatitude: CommonUtils.userLocation.coordinate.latitude, baseLongitude: CommonUtils.userLocation.coordinate.longitude)
    }
    
    func generateAdditionalThreatData(baseLatitude: Double, baseLongitude: Double) -> [ThreatLocation] {
        var additionalThreatData: [ThreatLocation] = []

        for _ in 0..<50 {
            let newLatitude = baseLatitude + Double.random(in: -0.0002...0.0002)
            let newLongitude = baseLongitude + Double.random(in: -0.0002...0.0002)
            let threatIndex = Int.random(in: 1...100)
            
            let newThreatLocation = ThreatLocation(latitude: newLatitude, longitude: newLongitude, threatIndex: threatIndex)
            additionalThreatData.append(newThreatLocation)
        }
        
        return additionalThreatData
    }
}
