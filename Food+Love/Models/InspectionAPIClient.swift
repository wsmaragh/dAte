//
//  InspectionAPIKeys.swift
//  Food+Love
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

class InspectionAPIClient {
    private init(){}
    private let appToken = "EZMGvpQwHXS5NwGjdwwgm9j0H"
    private let baseURLStr = "https://data.cityofnewyork.us/resource/9w7m-hzhe.json?"
    static let manager = InspectionAPIClient()
    func getInspection(zipcode: String,
                       venue: String,
                       completionHandler: @escaping (Inspection) -> Void,
                errorHandler: @escaping (Error) -> Void) {
        
        let urlStr =  "\(baseURLStr)$$app_token=\(appToken)&zipcode=\(zipcode)&dba=\(venue)&$order=inspection_date DESC&$limit=1"
        guard let url = URL(string: urlStr) else {return}
        
        let parseData = {(data: Data) in
            do {
                let inspectionOnline = try JSONDecoder().decode(Inspection.self, from: data)
                    completionHandler(inspectionOnline)
            } catch let error {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(withURL: url, completionHandler: parseData, errorHandler: errorHandler)
    }
}
