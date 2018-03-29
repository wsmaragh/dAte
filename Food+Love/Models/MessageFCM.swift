//
//  MessageFCM.swift
//  Food+Love
//
//  Created by C4Q on 3/28/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

struct MessageFCM: Codable {
    let to: String
    let notification: NotificationFCM
    let data: NotificationFCM
    
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
}

