//
//  NetworkFilter.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension ObservableType where Self.E == Moya.Response {
    public func filterSuccessfulHttp() -> RxSwift.Observable<Moya.Response> {
        return flatMap { response -> Observable<E> in
            if (200...299).contains(response.statusCode) {
                return Observable.just(response)
            } else if response.statusCode == 401 {
                //Handle TokenExpired
                return Observable.error(ErrorServer.tokenExpired)
            } else {
                do {
                    let data = try response.mapJSON()
                    if let error = data as? [String : Any] {
                        if let error = error["error"] as? [String : Any], let message = error["message"] as? String {
                            return Observable.error(ErrorServer.failed(code: response.statusCode, message: message))
                        }
                    }
                } catch {
                    return Observable.error(ErrorServer.failed(code: response.statusCode, message: nil))
                }
                
                return Observable.error(ErrorServer.failed(code: response.statusCode, message: nil))
            }
        }
    }
}
