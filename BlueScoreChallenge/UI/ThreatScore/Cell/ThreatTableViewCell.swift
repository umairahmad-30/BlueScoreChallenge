//
//  ThreatTableViewCell.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 23/08/23.
//

import UIKit

class ThreatTableViewCell: UITableViewCell {
    
    let electronicDeviceNames: [String] = [
        "Smartphone",
        "Laptop",
        "Tablet",
        "Smart TV",
        "Smartwatch",
        "Gaming Console",
        "Smart Speaker",
        "Thermostat",
        "Security Camera",
        "Wireless Printer",
        "Smart Doorbell",
        "Fitness Tracker",
        "Wireless Headphones",
        "Smart Lightbulb",
        "Home Assistant",
        "Wireless Router",
        "Streaming Device",
        "Smart Refrigerator",
        "Wireless Mouse",
        "Baby Monitor"
    ]
    
    @IBOutlet private var threatLabel: UILabel!
    @IBOutlet weak var threatDeviceLabel: UILabel!
    
    func configure(threatIndex: Int) {
        threatDeviceLabel.text = electronicDeviceNames.randomElement()
        threatLabel.text = "\(threatIndex)"
        threatLabel.textColor = threatColor(for: threatIndex)
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
