//
//  FilmNavigator.swift
//  Application
//
//  Created by Vu Doan on 12/23/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit

protocol FilmNavigator {
    func book(link: String)
    func getNavigationController() -> UINavigationController
}

class DefaultFilmNavigator: FilmNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func book(link: String) {
        
    }

    func getNavigationController() -> UINavigationController {
        return self.navigationController
    }
}
