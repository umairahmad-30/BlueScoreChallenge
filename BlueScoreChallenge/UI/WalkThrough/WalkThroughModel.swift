//
//  WalkThroughModel.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 22/08/23.
//

import Foundation


struct Permission {
    var type: PermissionType
    var isGranted: Bool
}

enum PermissionType {
    case location
    case notification
}
