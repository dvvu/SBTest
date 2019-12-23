//
//  Observable+MoyaExtension.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension ObservableType where E == Response {
    public func map<D: Mappable>(failsOnEmptyData: Bool, mapper: Mapper<D> = Mapper()) -> Observable<D?> {
        return flatMap { tkResponse in
            return tkResponse.map(failsOnEmptyData: failsOnEmptyData, mapper: mapper)
        }
    }
    
    public func map<D: Mappable>(failsOnEmptyData: Bool, mapper: Mapper<D> = Mapper()) -> Observable<Array<D>> {
        return flatMap { tkResponse in
            return tkResponse.map(failsOnEmptyData: failsOnEmptyData, mapper: mapper)
        }
    }
}

extension Response {
    public func map<D: Mappable>(failsOnEmptyData: Bool, mapper: Mapper<D> = Mapper()) -> Observable<D?> {
        
        let jsonData: Data = data
        if jsonData.count < 1 && !failsOnEmptyData {
            if let emptyJSONObjectData = "{}".data(using: .utf8), let emptyDecodableValue = mapper.map(JSONObject: emptyJSONObjectData)  {
                return Observable.just(emptyDecodableValue)
            } else if let emptyJSONArrayData = "[{}]".data(using: .utf8), let emptyDecodableValue = mapper.map(JSONObject: emptyJSONArrayData) {
                return Observable.just(emptyDecodableValue)
            }
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) else {
            return Observable.just(nil)
        }
        
        if let jsonDics = jsonObject as? [String: Any] {
            return Observable.just(mapper.map(JSON: jsonDics))
        }
        
        return Observable.empty()
    }
    
    public func map<D: Mappable>(failsOnEmptyData: Bool, mapper: Mapper<D> = Mapper()) -> Observable<Array<D>> {
        
        let jsonData: Data = data
        if jsonData.count < 1 && !failsOnEmptyData {
            return Observable.just([])
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) else {
            return Observable.just([])
        }
        
        if let data = jsonObject as? [String : Any] {
            let data = data["data"]
            return Observable.just(mapper.mapArray(JSONObject: data) ?? [])
        }
        return Observable.just(mapper.mapArray(JSONObject: jsonObject) ?? [])
    }
}
