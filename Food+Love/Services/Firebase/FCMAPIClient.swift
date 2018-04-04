//
//  FCMAPIClient.swift
//  Food+Love
//
//  Created by C4Q on 3/28/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

class FCMAPIClient {
    private init() {}
    static let manager = FCMAPIClient()
    public func sendPushNotification(device: String, title: String, message: String) {
        guard let urlFMC = URL(string: FCMKeys.fcmEndpoint) else {return}
        var urlRMCRequest = URLRequest(url: urlFMC)
        urlRMCRequest.setValue(FCMKeys.serverKey, forHTTPHeaderField: "Authorization")
        urlRMCRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRMCRequest.httpMethod = "POST"
        
        let notification = NotificationFCM(body: message, title: title, content_available: true, priority: "high", sound: "default")
        let body = BodyFCM(body: message, title: title)
        let messageFCM = MessageFCM(to: device, notification: notification, data: body)
        let jsonMessage = messageFCM.toAny()
        urlRMCRequest.httpBody = jsonMessage
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRMCRequest) { (data, response, error) in
            if let error = error {
                print("------FCM error:", error, "------")
                return
            }
            DispatchQueue.main.async {
                guard let response = response else {return}
                guard let data = data else {return}
                print("------ Message response:", response, "------")
                print("------ Message data:", data, "------")
                print()
                print("------ Message sent ------")
            }
        }
        task.resume()
    }
}
