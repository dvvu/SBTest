//
//  HomeViewController.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: MovieViewModel?
    private var navigation: HomeNavigator?
    private let disposeBag = DisposeBag()
    private var loadPage = PublishSubject<Bool>()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<MovieSection> = {
        return skinDataSource()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        bindViewModel()
    }
    
    func setModelNavigation(_ viewModel: MovieViewModel, navigation: HomeNavigator) {
        self.viewModel = viewModel
        self.navigation = navigation
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        let viewDetailTrigger = self.tableView.rx.itemSelected.map { indexpath in
            indexpath
        }
        let input: MovieViewModel.Input = MovieViewModel.Input(viewDetailTrigger: viewDetailTrigger, loadPage: loadPage.asObservable())
       
        let output = viewModel.transform(input: input)
        output.viewDetailProduct.drive(onNext: { [weak self] movie in
           guard let strongSelf = self, let item = movie, let nav = strongSelf.navigation else { return }
            nav.toDetail(product: item)
        }).disposed(by: disposeBag)
        
        self.loadPage.onNext(true)
        output.dataSource.drive(self.tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        output.error.drive(bindError).disposed(by: disposeBag)
        output.fetching.drive(indicator).disposed(by: disposeBag)
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
    
    private func configTableView() {
        self.title = "Movies"
        tableView.contentOffset = .zero
        tableView.register(FilmTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.estimatedRowHeight = 44
        
        tableView.addPullToRefresh(direction: .Vertical, action: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.handlePushToRequest()
        })

        tableView.addLoadMore(direction: .Vertical, action: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.handleLoadMore()
        })
    }
    
    private func handlePushToRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadPage.onNext(true)
            self.tableView.stopPullToRefresh()
        }
    }
    
    private func handleLoadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadPage.onNext(false)
            self.tableView.stopLoadMore()
        }
    }
    
    private func skinDataSource()-> RxTableViewSectionedReloadDataSource<MovieSection> {
        let tableDataSource = RxTableViewSectionedReloadDataSource<MovieSection>(configureCell: { (datasource, tableView, indexPath, item) -> UITableViewCell in
            let cell: FilmTableViewCell = tableView.dequeueReusableCell(at: indexPath)
                as FilmTableViewCell
            switch item {
            case .Movie(let item):
                cell.setupData(item)
            }
            return cell
        })
        return tableDataSource
    }
}


