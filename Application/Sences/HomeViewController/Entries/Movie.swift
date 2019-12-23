//
//  Movie.swift
//  Application
//
//  Created by Vu Doan on 12/18/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

class Movie: Mappable {
    var page: Int?
    var totalPages: Int?
    var totalResult: Int?
    var results: [MovieItem]?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        page <- map["grand_total"]
        totalPages <- map["status_text"]
        totalResult <- map["is_cover"]
        results <- map["results"]
    }
}

class MovieItem: Mappable {
    var popularity: CGFloat?
    var id: Int?
    var video: Bool?
    var voteCount: Int?
    var voteAverage: CGFloat?
    var title: String?
    var releaseDate: Date?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIds: [Int]?
    var backdropPath: String?
    var adult: Bool?
    var overview: String?
    var posterPath: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        popularity <- map["popularity"]
        id <- map["id"]
        releaseDate <- (map["release_date"], DateTransform(unit: .seconds))
        video <- map["video"]
        voteCount <- map["vote_count"]
        voteAverage <- map["vote_average"]
        posterPath <- map["poster_path"]
        title <- map["title"]
    }
}
