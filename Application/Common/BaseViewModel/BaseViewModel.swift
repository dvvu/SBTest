//
//  BaseViewModel.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class TKAccountBaseViewModel {
    var disposeBag = DisposeBag()
    lazy var errorTracker: ErrorTracker = {
        return ErrorTracker()
    }()
    
    lazy var activityIndicator: ActivityIndicator = {
        return ActivityIndicator()
    }()
}
