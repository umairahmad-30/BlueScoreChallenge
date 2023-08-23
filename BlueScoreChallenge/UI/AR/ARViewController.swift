//
//  ARViewController.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 22/08/23.
//

import UIKit
import ARCL
import CoreLocation
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet private var sceneView: SceneLocationView!

    private var viewModel: ARViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ARViewModel()

        setupScene()
        addThreatSpheresToScene()
    }

    private func setupScene() {
        sceneView.showAxesNode = false
        sceneView.showFeaturePoints = true
        sceneView.run()
    }

    private func addThreatSpheresToScene() {
        for location in viewModel.threatData {
            addSphere(at: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), threatIndex: location.threatIndex)
        }
    }

    private func addSphere(at coordinate: CLLocationCoordinate2D, threatIndex: Int) {
        
        // Convert the latitude and longitude to CLLocation
        let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: CommonUtils.userLocation.altitude + Double.random(in: -10.0...10.0))

        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100.0, height: 100.0)))
        let sphereImage = (UIImage(named: "sphere")?.withRenderingMode(.alwaysTemplate))!
        imageView.image = sphereImage
        imageView.tintColor = threatColor(for: threatIndex)
        
        // Create an ARNode and place it at the given CLLocation
        let arNode = LocationAnnotationNode(location: location, view: imageView)
        let textNode = createTextNode(text: "\(threatIndex)")
        
        arNode.continuallyUpdatePositionAndScale = true
        arNode.continuallyAdjustNodePositionWhenWithinRange = true
        arNode.scaleRelativeToDistance = true
        let textPosition = SCNVector3(x: arNode.worldOrientation.x, y: arNode.worldOrientation.y + 0.1, z: arNode.worldOrientation.z) // Adjust text's vertical position
        
        textNode.position = textPosition
        arNode.addChildNode(textNode)
        // Add the ARNode to the ARView
        sceneView.addLocationNodeWithConfirmedLocation(locationNode: arNode)
        
    }

    private func createTextNode(text: String) -> SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 0.02)
        let textNode = SCNNode(geometry: textGeometry)
        
        textNode.scale = SCNVector3(0.02, 0.02, 0.02)
        textNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        return textNode
    }

    private func threatColor(for threatIndex: Int) -> UIColor {
        switch threatIndex {
        case 1...20: return .systemGreen
        case 21...40: return .systemYellow
        case 41...60: return .systemOrange
        case 61...80: return .systemRed
        default: return .systemPink
        }
    }

    
    @IBAction func closeButtonTapped(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil)
    }
}

