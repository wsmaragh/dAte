//
//  PlanDate.swift
//  Food+Love
//
//  Created by C4Q on 3/29/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PlanDate: Codable {
    var ref: String?
    var loverFrom: String?
    var loverTo: String?
    var hour: String?
    var date: String?
    var dayId: String?
    var monthId: String?
    var yearId: String?
    var monthStr: String?
    var venueId: String?
    var restaurant: String?
    var address: String?
    var confirmed: Int
    
    init(snapShot: DataSnapshot) {
        let dict = snapShot.value as? [String: Any]
        self.ref = snapShot.ref.key
        self.loverFrom = dict?["loverFrom"] as? String ?? ""
        self.loverTo = dict?["loverTo"] as? String ?? ""
        self.hour = dict?["hour"] as? String
        self.date = dict?["date"] as? String ?? ""
        self.dayId = dict?["dayId"] as? String ?? ""
        self.monthId = dict?["monthId"] as? String ?? ""
        self.yearId = dict?["yearId"] as? String ?? ""
        self.monthStr = dict?["monthStr"] as? String ?? ""
        self.venueId = dict?["venueId"] as? String ?? ""
        self.restaurant = dict?["restaurant"] as? String ?? ""
        self.address = dict?["address"] as? String ?? ""
        self.confirmed = dict?["confirmed"] as? Int ?? 0
    }
    
    init(loverFrom: String, loverTo: String,
         hour: String, date: String, dayId: String,
         monthId: String, yearId: String,
         monthStr: String, venueId: String,
         restaurant: String, address: String, confirmed: Int) {
        self.loverFrom = loverFrom
        self.loverTo = loverTo
        self.hour = hour
        self.date = date
        self.dayId = dayId
        self.monthId = monthId
        self.yearId = yearId
        self.monthStr = monthStr
        self.venueId = venueId
        self.restaurant = restaurant
        self.address = address
        self.confirmed = confirmed
    }
    
    func toAny() -> [String: Any] {
        return ["loverFrom": loverFrom ?? "",
                "loverTo": loverTo ?? "",
                "hour": hour ?? "",
                "date": date ?? "",
                "dayId": dayId ?? "",
                "monthId": monthId ?? "",
                "yearId": yearId ?? "",
                "monthStr": monthStr ?? "",
                "venueId": venueId ?? "",
                "restaurant": restaurant ?? "",
                "address": address ?? "",
                "confirmed": confirmed]
    }
}
