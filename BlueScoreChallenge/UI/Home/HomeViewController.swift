//
//  HomeViewController.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 22/08/23.
//

import UIKit
import GoogleMaps
import Lottie
import UserNotifications

class HomeViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet weak var swipeDownView: UIView!
    @IBOutlet weak var swipeDownAnimationView: LottieAnimationView!
    @IBOutlet weak var blueScoreView: UIView!
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupMapView()
        setupSwipeDownView()
        setupBlueScoreView()
        setupAnimationView()
        
        let averageThreatIndex = Int(ceil(Double(viewModel.threatData.map({ $0.threatIndex }).reduce(0, +) / viewModel.threatData.count)))
        let notificationMessage = "Your Cyber Threat Index is \(averageThreatIndex). Stay vigilant."
        scheduleLocalNotification(withMessage: notificationMessage)
    }
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        // Add the threat annotations to the map
        viewModel.threatAnnotations.forEach { annotation in
            annotation.map = mapView
        }
        
        // Add the threat heatmap overlay to the map
        let heatmapLayer = viewModel.threatHeatmap
        heatmapLayer.map = mapView

        // Zoom the map to the area around current location
        let currentLocation = CLLocationCoordinate2D(latitude: CommonUtils.userLocation.coordinate.latitude, longitude: CommonUtils.userLocation.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 19)
        mapView.camera = camera
    }
    
    private func setupSwipeDownView() {
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 1.0
        blurView.frame = swipeDownView.frame
        swipeDownView.addSubview(blurView)
        swipeDownView.sendSubviewToBack(blurView)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeGesture.direction = .down
        swipeDownView.addGestureRecognizer(swipeGesture)
    }
    
    private func setupBlueScoreView() {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blueScoreView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blueScoreView.addSubview(blurEffectView)
        blueScoreView.sendSubviewToBack(blurEffectView)
        
        blueScoreView.clipsToBounds = true
        blueScoreView.layer.cornerRadius = 10.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBlueScoreTap(_:)))
        blueScoreView.addGestureRecognizer(tapGesture)
    }
    
    private func setupAnimationView() {
        swipeDownAnimationView.contentMode = .scaleAspectFit
        swipeDownAnimationView.loopMode = .loop
        swipeDownAnimationView.animationSpeed = 1.0
        swipeDownAnimationView.play()
    }
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let arViewController = storyboard.instantiateViewController(identifier: "ARViewController") as! ARViewController
            arViewController.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(arViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func handleBlueScoreTap(_ gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let threatViewController = storyboard.instantiateViewController(identifier: "ThreatViewController") as! ThreatViewController
        threatViewController.blueScore = ceil(Double(viewModel.threatData.map({ $0.threatIndex }).reduce(0, +) / viewModel.threatData.count))
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(threatViewController, animated: true, completion: nil)
    }
}

extension HomeViewController {

    func scheduleLocalNotification(withMessage message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Cyber Thread Alert"
        content.body = message
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "threatNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
