//
//  WalkThroughModelTests.swift
//  BlueScoreChallengeTests
//
//  Created by Umair Ahmad on 22/08/23.
//

import XCTest
@testable import BlueScoreChallenge

class WalkthroughViewModelTests: XCTestCase {
    var viewModel: WalkthroughViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = WalkthroughViewModel()
    }
    
    func testRequestLocationPermission() {
        let expectation = XCTestExpectation(description: "Location permission request")
        
        viewModel.requestLocationPermission { isGranted in
            XCTAssertTrue(isGranted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRequestNotificationPermission() {
        let expectation = XCTestExpectation(description: "Notification permission request")
        
        viewModel.requestNotificationPermission { isGranted in
            XCTAssertTrue(isGranted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
