//
//  MovieUseCase.swift
//  Application
//
//  Created by Vu Doan on 12/18/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

protocol MovieUseCaseProvider {
    func loadMovies(_ page: Int)-> Observable<Movie?>
}

class MovieUseCase: MovieUseCaseProvider {
    func loadMovies(_ page: Int) -> Observable<Movie?> {
        return RxEAProvider.rx.request(.movies(page: page))
            .asObservable()
            .filterSuccessfulHttp()
            .map(failsOnEmptyData: false)
            .map{ $0 }
            .unwrap()
    }
}

