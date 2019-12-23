//
//  MovieSectionData.swift
//  Application
//
//  Created by Vu Doan on 12/18/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources

enum MovieSectionItem {
    case Movie(MovieItem)
}

enum MovieSection {
    case Film(header: HeaderData, items: [MovieSectionItem])
}

extension MovieSection: SectionModelType {
    typealias Item = MovieSectionItem
    
    init(original: MovieSection, items: [MovieSection.Item]) {
        switch original {
        case let .Film(header: header, items: _):
            self = .Film(header: header, items: items)
        }
    }
    
    var items: [MovieSection.Item] {
        switch self {
        case .Film(header: _, items: let items):
            return items
        }
    }
    
    var header: HeaderData {
        switch self {
        case .Film(header: let header, items: _):
            return header
        }
    }
}

// header
struct HeaderData {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.name = name
        self.id = id
    }
}
