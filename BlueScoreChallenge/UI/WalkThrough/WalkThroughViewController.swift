//
//  WalkThroughViewController.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 22/08/23.
//

import Foundation
import UIKit

class WalkthroughViewController: UIViewController {
    @IBOutlet weak var permissionLabel: UILabel!
    @IBOutlet weak var permissionImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var viewModel: WalkthroughViewModel!
    var currentPermissionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        updateUI()
    }
    
    private func setupViewModel() {
        viewModel = WalkthroughViewModel()
    }
    
    func updateUI() {
        let currentPermission = viewModel.permissions[currentPermissionIndex]
        
        switch currentPermission.type {
        case .location:
            UIView.transition(with: permissionLabel,
                          duration: 0.25,
                           options: .transitionCrossDissolve,
                        animations: { [weak self] in
                self?.permissionLabel.text = "The application needs your location to provide accurate Cyber Threats near you"
            }, completion: nil)
            UIView.transition(with: permissionImage,
                          duration: 0.25,
                           options: .transitionCrossDissolve,
                        animations: { [weak self] in
                self?.permissionImage.image = UIImage(named: "location")
            }, completion: nil)
        case .notification:
            UIView.transition(with: permissionLabel,
                          duration: 0.25,
                           options: .transitionCrossDissolve,
                        animations: { [weak self] in
                self?.permissionLabel.text = "The application needs notifications to let you know when you are in high threat areas"
            }, completion: nil)
            UIView.transition(with: permissionImage,
                          duration: 0.25,
                           options: .transitionCrossDissolve,
                        animations: { [weak self] in
                self?.permissionImage.image = UIImage(named: "notification")
            }, completion: nil)
        }
        
        UIView.transition(with: nextButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.nextButton.setTitle("Next", for: .normal)
            self.nextButton.setTitleColor(UIColor.black, for: .normal)
        }, completion: nil)
        
        UIView.transition(with: skipButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.skipButton.setTitle("Skip", for: .normal)
            self.skipButton.setTitleColor(UIColor.black, for: .normal)
        }, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if currentPermissionIndex > viewModel.permissions.count {
            return
        }
        
        let currentPermission = viewModel.permissions[currentPermissionIndex]
        
        if currentPermission.isGranted {
            moveToNextPermission()
        } else {
            requestPermission()
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        requestPermission()
    }
    
    func requestPermission() {
        if currentPermissionIndex > viewModel.permissions.count {
            return
        }
        
        var currentPermission = viewModel.permissions[currentPermissionIndex]
        
        switch currentPermission.type {
        case .location:
            viewModel.requestLocationPermission { [weak self] isGranted in
                currentPermission.isGranted = isGranted
                self?.moveToNextPermission()
            }
        case .notification:
            viewModel.requestNotificationPermission { [weak self] isGranted in
                currentPermission.isGranted = isGranted
                self?.moveToNextPermission()
            }
        }
    }
    
    func moveToNextPermission() {
        currentPermissionIndex += 1
        
        if currentPermissionIndex < viewModel.permissions.count {
            updateUI()
        } else {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                homeViewController.modalPresentationStyle = .fullScreen
                self.present(homeViewController, animated: true)
            }
        }
    }
}
