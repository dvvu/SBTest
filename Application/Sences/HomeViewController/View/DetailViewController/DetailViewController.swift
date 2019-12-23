//
//  DetailViewController.swift
//  Application
//
//  Created by Vu Doan on 12/23/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class DetailViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private var viewModel: FilmDetailViewModel?
    private var navigation: FilmNavigator?
    private var loadPage = PublishSubject<Void>()
    private var book = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    func setModelNavigation(_ viewModel: FilmDetailViewModel, navigation: DefaultFilmNavigator) {
        self.viewModel = viewModel
        self.navigation = navigation
    }
    
    private func configView() {
        self.title = "Film Detail"
        scrollView.addPullToRefresh(direction: .Vertical, action: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.handlePushToRequest()
        })
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        let input: FilmDetailViewModel.Input = FilmDetailViewModel.Input(book: book, loadPage: loadPage.asObservable())
        let output = viewModel.transform(input: input)
        output.error.drive(bindError).disposed(by: disposeBag)
        output.fetching.drive(indicator).disposed(by: disposeBag)
        output.film.drive(onNext: { [weak self] film in
            guard let strongSelf = self, let film = film else {return}
            strongSelf.setupView(film)
        }).disposed(by: disposeBag)
        self.loadPage.onNext(())
    }
    
    private var bindError: Binder<Error?> {
        return Binder(self) { vc, error in
            RxUtils.alert(title: "Error", text: error?.localizedDescription ,dismissTitle: "Ok").mapToVoid()
                .asDriverOnErrorJustComplete()
                .mapToVoid()
                .drive()
                .disposed(by: self.disposeBag)
        }
    }
    
    private func handlePushToRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadPage.onNext(())
            self.scrollView.stopPullToRefresh()
        }
    }
    
    private func setupView(_ film: Film) {
        self.itemImageView.sd_setImage(with: URL(string: Constant.rootImage + (film.posterPath ?? "")), placeholderImage: UIImage(named: "ic_placeholder"))
        self.overviewLabel.text = film.overview ?? ""
        self.titleLabel.text = film.originalTitle ?? ""
        self.durationLabel.text = "\(film.runTime ?? 0) minutes"
        self.genresLabel.text = film.genres?.map({ (genre) -> String in
            return genre.name ?? ""
        }).joined(separator:"/")
    }
}
