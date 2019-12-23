//
//  FilmDetailUseCase.swift
//  Application
//
//  Created by Vu Doan on 12/23/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

protocol FilmDetailUseCaseProvider {
    func getFilmDetail(_ id: Int)-> Observable<Film?>
}

class FilmDetailUseCase: FilmDetailUseCaseProvider {
    func getFilmDetail(_ id: Int) -> Observable<Film?> {
        return RxEAProvider.rx.request(.film(id: id))
            .asObservable()
            .filterSuccessfulHttp()
            .map(failsOnEmptyData: false)
            .map{ $0 }
            .unwrap()
    }
}
