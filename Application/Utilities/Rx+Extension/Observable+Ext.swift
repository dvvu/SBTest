//
//  Observable+Ext.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> SharedSequence<SharingStrategy, T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func track(activity: ActivityIndicator, error: ErrorTracker) -> Driver<E> {
        return self.trackActivity(activity)
            .trackError(error)
            .asDriverOnErrorJustComplete()
    }
}

extension ObservableType {
    func unwrap<T>() -> Observable<T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}

extension ObservableType {
    public func nwise(_ n: Int) -> Observable<[E]> {
        return self
            .scan([]) { acc, item in Array((acc + [item]).suffix(n)) }
            .filter { $0.count == n }
    }
    
    public func pairwise() -> Observable<(E, E)> {
        return self.nwise(2)
            .map { ($0[0], $0[1]) }
    }
    
    public func ternate() -> Observable<(E, E, E)> {
        return self.nwise(3)
            .map { ($0[0], $0[1], $0[2]) }
    }
}

extension SharedSequenceConvertibleType {
    public func nwise(_ n: Int) -> SharedSequence<SharingStrategy, [E]> {
        return self
            .scan([]) { acc, item in Array((acc + [item]).suffix(n)) }
            .filter { $0.count == n }
    }
    
    public func pairwise() -> SharedSequence<SharingStrategy, (E, E)> {
        return self.nwise(2)
            .map { ($0[0], $0[1]) }
    }
    
    public func ternate() -> SharedSequence<SharingStrategy, (E, E, E)> {
        return self.nwise(3)
            .map { ($0[0], $0[1], $0[2]) }
    }
}

extension ConnectableObservableType {
    func autoconnect() -> Observable<E> {
        return Observable.create { observer in
            return self.do(onSubscribe: {
                _ = self.connect()
            }).subscribe { (event: Event<Self.E>) in
                switch event {
                case .next(let value):
                    observer.on(.next(value))
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
        }
    }
}
