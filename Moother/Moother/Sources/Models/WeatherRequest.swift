//
//  WeatherRequest.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/06.
//

import Foundation

struct WeatherRequest: Codable {
    var lat: Double
    var lon: Double
    var appid: String
    var units: String
    var lang: String
    
    init(_ lat: Double,_ lon: Double,_ appid: String) {
        self.lat = lat
        self.lon = lon
        self.appid = appid
        self.units = "metric"
        self.lang = "kr"
    }
}
