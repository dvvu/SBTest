//
//  HomeNavigator.swift
//  Application
//
//  Created by Vu Doan on 12/18/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit

protocol HomeNavigator {
    func toDetail(product: MovieItem)
    func getNavigationController() -> UINavigationController
}

class DefaultHomeNavigator: HomeNavigator {
    private let navigationController: UINavigationController
 
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toDetail(product: MovieItem) {
        let vc = DetailViewController(nibName: "DetailViewController", bundle: nil)
        if let id = product.id {
            let viewModel = FilmDetailViewModel(filmId: id, useCase: FilmDetailUseCase())
            vc.setModelNavigation(viewModel, navigation: DefaultFilmNavigator(navigationController: self.navigationController))
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func getNavigationController() -> UINavigationController {
        return self.navigationController
    }
}

