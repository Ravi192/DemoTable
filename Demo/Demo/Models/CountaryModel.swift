//
//  CountaryModel.swift
//  Demo
//
//  Created by RAVIKANT KUMAR on 18/07/20.
//  Copyright © 2020 Societe Generale. All rights reserved.
//

import Foundation


struct CountaryModel: Codable {
    var title: String?
    var rows: [Rows]
}
//// MARK: - Row
struct Rows: Codable {
    let title: String?
    let description: String?
    let imageHref: String?
}
