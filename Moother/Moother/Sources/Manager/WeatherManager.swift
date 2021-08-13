//
//  WeatherManager.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/12.
//

import UIKit

import Moya

class WeatherManager {
    static var shared: WeatherManager = WeatherManager()
    
    private let authProvider = MoyaProvider<WeatherService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private var weatherModel: WeatherResponse?
    
    func fetchWeatherInfo(lat: Double, lon: Double, completion: @escaping ((WeatherResponse) -> ())) {
        let param = WeatherRequest.init(lat, lon, GeneralAPI.appid)
        
        authProvider.request(.main(param: param)) { response in
            switch response {
            case .success(let result):
                do {
                    self.weatherModel = try result.map(WeatherResponse.self)
                    completion(self.weatherModel!)
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
