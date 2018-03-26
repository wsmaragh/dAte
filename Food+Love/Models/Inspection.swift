//
//  InspectionJSON.swift
//  Food+Love
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

struct Inspection: Codable {
    let id: String
    let name: String
    let boro: String
    let building: String
    let street: String
    let zipcode: String
    let phone: String
    let cuisineDescription: String
    let inspectionDate: String
    let inspectionType: String
    let action: String
    let violationCode: String
    let violationDescription: String
    let criticalFlag: String
    let score: String
    let grade: String
    let gradeDate: String
    let recordDate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "camis"
        case name = "dba"
        case boro
        case building
        case street
        case zipcode
        case phone
        case cuisineDescription = "cuisine_description"
        case inspectionDate = "inspection_date"
        case inspectionType = "inspection_type"
        case action
        case violationCode = "violation_code"
        case violationDescription = "violation_description"
        case criticalFlag = "critical_flag"
        case score
        case grade
        case gradeDate = "grade_date"
        case recordDate = "record_date"
    }
}

