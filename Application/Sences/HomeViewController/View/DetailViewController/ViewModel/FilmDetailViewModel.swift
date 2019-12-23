//
//  FilmDetailViewModel.swift
//  Application
//
//  Created by Vu Doan on 12/23/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class FilmDetailViewModel: TKAccountBaseViewModel, ViewModelType {
 
    private let useCase: FilmDetailUseCase
    private var film: Film?
    var filmId: Int
    
    init(filmId: Int, useCase: FilmDetailUseCase) {
        self.filmId = filmId
        self.useCase = useCase
    }
    
    struct Input {
        let book: Observable<Void>
        let loadPage: Observable<Void>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<Error>
        let book: Driver<String?>
        let film: Driver<Film?>
    }
    
    func transform(input: Input) -> Output {
        let filmOp = input.loadPage.flatMap { [weak self] (_) -> Observable<Film?> in
            guard let strongSelf = self else {
                return .just(nil)
            }
              return strongSelf.getFilmDetail(id: strongSelf.filmId)
            }.asDriver(onErrorJustReturn: nil)
            .do(onNext: { [weak self] (film) in
                guard let strongSelf = self else { return }
                strongSelf.film = film
            })

        let bookOp = input.book.map { [weak self] (_) -> String? in
            guard let strongSelf = self, let film = strongSelf.film else {return nil}
            return film.homePage ?? ""
        }.asDriver(onErrorJustReturn: nil)
        
        return Output(fetching: activityIndicator.asDriver(),
                      error: errorTracker.asDriver(),
                      book: bookOp.asDriver(),
                      film: filmOp)
    }
}

extension FilmDetailViewModel {
    func getFilmDetail(id: Int) -> Observable<Film?> {
        return useCase.getFilmDetail(id)
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
    }
}
