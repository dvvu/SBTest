//
//  Film.swift
//  Application
//
//  Created by Vu Doan on 12/23/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

class Film: Mappable {
    var genres: [Genre]?
    var overview: String?
    var originalTitle: String?
    var originalLanguage: String?
    var runTime: Int?
    var homePage: String?
    var backdropPath: String?
    var posterPath: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        genres <- map["genres"]
        overview <- map["overview"]
        originalTitle <- map["original_title"]
        originalLanguage <- map["original_language"]
        runTime <- map["runtime"]
        homePage <- map["homepage"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
    }
}

class Genre: Mappable {
    var id: Int?
    var name: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
