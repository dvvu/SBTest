//
//  VDNetworkAPI.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import Moya

let RxEAProvider = MoyaProvider<VDTarget>(manager: DefaultAlamofireManager.sharedManager, plugins: [NetworkLoggerPlugin(verbose: true)])

enum VDTarget {
    case movies(page: Int)
    case film(id: Int)
}

extension VDTarget: TargetType {
    public var baseURL: URL {
        switch self {
        case .movies(let page):
            return URL(string: "\(Constant.movies)\(page)")!
        case .film(let id):
            return URL(string: "\(Constant.baseURL)movie/\(id)?api_key=\(Constant.apiKey)")!
        }
    }
    
    public var path: String {
        switch self {
        case .movies:
            return ""
        case .film:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .movies, .film:
            return .get
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .movies:
            return .requestPlain
        case .film:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "{\"data\": 12}".data(using: String.Encoding.utf8)!
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        switch self {
        case .movies, .film:
            break
        default:
            headers["Authorization"] = Session.shared.token ?? ""
        }
        return headers
    }
}

extension Moya.Task {
    static func requestHWJSONEncodable(_ params: Encodable) -> Moya.Task {
        return .requestCustomJSONEncodable(params, encoder: Constant.jsonEncoder)
    }
}

