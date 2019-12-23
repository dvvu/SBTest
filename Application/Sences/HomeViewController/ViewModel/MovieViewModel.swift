//
//  MovieViewModel.swift
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

class MovieViewModel: TKAccountBaseViewModel, ViewModelType {
    private var currentPage = 1
    private let useCase: MovieUseCase
    let sections = BehaviorRelay<[MovieSection]>(value: [])
    
    init(useCase: MovieUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let viewDetailTrigger: Observable<IndexPath>
        let loadPage: Observable<Bool>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<Error>
        let dataSource: Driver<[MovieSection]>
        let viewDetailProduct: Driver<MovieItem?>
    }

    func transform(input: Input) -> Output {
        input.loadPage.flatMap { [weak self] (isPullToRefesh) -> Observable<Movie?> in
            guard let strongSelf = self else {
                return .just(nil)
            }
            strongSelf.currentPage = isPullToRefesh ? 1 : strongSelf.currentPage
            let newMovies = strongSelf.transformToMovieSections(page: strongSelf.currentPage)
            return newMovies
        }.map { [weak self] (movie) -> [MovieSection] in
            guard let strongSelf = self, let mov = movie else {
                return self?.sections.value ?? []
            }
            if let resultItems = mov.results, resultItems.count > 0 {
                strongSelf.currentPage += 1
            }
            return strongSelf.createSection(movie: mov)
            }.subscribe(onNext: { [weak self] (movieSections) in
                guard let strongSelf = self else { return }
                strongSelf.sections.accept(movieSections)
            }, onError: { [weak self] (error) in
                guard let strongSelf = self else { return }
                _ = strongSelf.transform(input: input)
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        let viewDetailProduct = input.viewDetailTrigger.map {[weak self] indexPath -> MovieItem? in
                guard let strongSelf = self  else {
                    return nil
                }
                let section = strongSelf.sections.value[indexPath.section]
                let item = section.items[indexPath.row]
                switch item {
                case .Movie(let itemData):
                    return itemData
                }
            }.filter{$0 != nil}.map{$0!}
            .asDriver(onErrorJustReturn: nil)
        
        return Output(fetching: activityIndicator.asDriver(),
                      error: errorTracker.asDriver(),
                      dataSource: sections.asDriver(),
                      viewDetailProduct: viewDetailProduct)
    }
}

extension MovieViewModel {
    func transformToMovieSections(page: Int) -> Observable<Movie?> {
        return useCase.loadMovies(page)
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
    }
    
    func createSection(movie: Movie) -> [MovieSection] {
        if let items = movie.results?.map({ (item) -> MovieSectionItem in
            return MovieSectionItem.Movie(item)
        }), items.count > 0 {
            var oldSections = self.sections.value
            if self.sections.value.count > 0 {
                let oldMovies = oldSections[0]
                var oldItems = oldMovies.items
                if self.currentPage == 2 {
                    oldItems = []
                }
                oldItems.append(contentsOf: items)
                let newSection = MovieSection.Film(header: oldMovies.header, items: oldItems)
                oldSections[0] = newSection
            } else {
                oldSections = [MovieSection.Film(header: HeaderData(id: 123, name: "Movie"), items: items)]
            }
            return oldSections
        } else {
            return self.sections.value
        }
    }
}
