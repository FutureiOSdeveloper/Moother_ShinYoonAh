//
//  WeatherService.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/06.
//

import Moya

enum WeatherService {
    case main(param: WeatherRequest)
}

extension WeatherService: TargetType {
    public var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var path: String {
        switch self {
        case .main:
            return "/onecall"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .main:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .main(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
