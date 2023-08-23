//
//  ARViewModel.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 22/08/23.
//

import Foundation
import ARKit
import GoogleMaps

class ARViewModel {
    
    // Simulated threat data
    var threatData = [ThreatLocation]()
    
    init() {
        self.threatData = generateAdditionalThreatData(baseLatitude: CommonUtils.userLocation.coordinate.latitude, baseLongitude: CommonUtils.userLocation.coordinate.longitude)
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
    
    // Generate colored annotations based on threat data
    var threatAnnotations: [GMSMarker] {
        return threatData.map { location in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            marker.title = "CTI: \(location.threatIndex)"
            marker.icon = GMSMarker.markerImage(with: threatColor(for: location.threatIndex))
            return marker
        }
    }

    // Determine the color based on the threat index
    private func threatColor(for threatIndex: Int) -> UIColor {
        switch threatIndex {
            case 1...20: return .systemGreen
            case 21...40: return .systemYellow
            case 41...60: return .systemOrange
            case 61...80: return .systemRed
            default: return .systemPink
        }
    }
}
