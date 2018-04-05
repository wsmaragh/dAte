//
//  MessageFCM.swift
//  Food+Love
//
//  Created by Marlon Rugama on 3/28/18.
//  Copyright © 2018 Marlon Rugama. All rights reserved.
//

import Foundation

struct MessageFCM: Codable {
    let to: String
    let notification: NotificationFCM
    let data: BodyFCM
    
    func toAny() -> Data {
        let jsonData = try! JSONEncoder().encode(self)
        return jsonData
    }
}

struct NotificationFCM: Codable {
    let body: String
    let title: String
    let content_available: Bool
    let priority: String
    let sound: String
}

struct BodyFCM: Codable {
    let body: String
    let title: String
}

