//
//  Constant.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation

class Constant {
    static var baseURL = "http://api.themoviedb.org/3/"
    static var apiKey = "328c283cd27bd1877d9080ccb1604c91"
    static var rootImage = "https://image.tmdb.org/t/p/w1280/"
    static var movies = baseURL + "discover/movie?api_key=\(apiKey)&primary_release_date.lte=2016-12-31&sort_by=release_date.desc&page="
}

extension Constant {
    static var jsonEncoder: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return jsonEncoder
    }
    
    static var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
}
