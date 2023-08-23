//
//  HomeViewModel.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 22/08/23.
//

import GoogleMaps
import GoogleMapsUtils

class HomeViewModel {
    
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
    
    // Generate a heatmap based on threat data
    var threatHeatmap: GMUHeatmapTileLayer {
        let heatMapLayer = GMUHeatmapTileLayer()
        
        let gradientColors: [UIColor] = [.systemGreen, .systemYellow, .systemOrange, .systemRed, .systemPink]
        let gradientStartPoints: [NSNumber] = [0.2, 0.4, 0.6, 0.8, 1.0]
        heatMapLayer.gradient = GMUGradient(colors: gradientColors, startPoints: gradientStartPoints, colorMapSize: 256)
        heatMapLayer.radius = 400
        heatMapLayer.opacity = 0.7
        heatMapLayer.maximumZoomIntensity = 80
        
        heatMapLayer.weightedData = threatData.map { location in
            let latLng = GMUWeightedLatLng(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), intensity: Float(Double(location.threatIndex)))
            return latLng
        }
        
        return heatMapLayer
    }
}
