//
//  WalkThroughViewControllerTests.swift
//  BlueScoreChallengeTests
//
//  Created by Umair Ahmad on 22/08/23.
//

import XCTest
@testable import BlueScoreChallenge

class WalkthroughViewControllerTests: XCTestCase {
    var viewController: WalkthroughViewController!
    var viewModel: WalkthroughViewModel!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController
        viewModel = WalkthroughViewModel()
        viewController.viewModel = viewModel
        viewController.loadViewIfNeeded()
    }
    
    func testUpdateUI_LocationPermission() {
        viewController.currentPermissionIndex = 0
        viewController.updateUI()
        
        XCTAssertEqual(viewController.permissionLabel.text, "The application needs your location to provide accurate Cyber Threats near you")
        XCTAssertEqual(viewController.nextButton.titleLabel?.text, "Next")
        XCTAssertEqual(viewController.skipButton.titleLabel?.text, "Skip")
    }
    
    func testUpdateUI_NotificationPermission() {
        viewController.currentPermissionIndex = 1
        viewController.updateUI()
        
        XCTAssertEqual(viewController.permissionLabel.text, "The application needs notifications to let you know when you are in high threat areas")
        XCTAssertEqual(viewController.nextButton.titleLabel?.text, "Next")
        XCTAssertEqual(viewController.skipButton.titleLabel?.text, "Skip")
    }
    
    func testNextButtonTapped_PermissionGranted() {
        viewModel.permissions[0].isGranted = true
        viewController.currentPermissionIndex = 0
        viewController.nextButtonTapped(viewController.nextButton)
        
        XCTAssertEqual(viewController.currentPermissionIndex, 1)
    }
    
    func testNextButtonTapped_PermissionNotGranted() {
        viewModel.permissions[0].isGranted = false
        viewController.currentPermissionIndex = 0
        viewController.nextButtonTapped(viewController.nextButton)
        
        // Assert that permission request is triggered
    }
    
    func testSkipButtonTapped() {
        viewController.currentPermissionIndex = 0
        viewController.skipButtonTapped(viewController.skipButton)
        
        XCTAssertEqual(viewController.currentPermissionIndex, 1)
    }
}
