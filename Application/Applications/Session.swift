//
//  Session.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation

class Session {
    static let shared = Session()
    
    private var tokenFromUserDefault: String?
    var token: String? {
        set {
//            tokenFromUserDefault = newValue
//            UserDefaults.standard.set(newValue, forKey: Constant.keyUserToken)
        }
        get {
            if tokenFromUserDefault == nil {
//                tokenFromUserDefault = UserDefaults.standard.object(forKey: Constant.keyUserToken) as? String
            }
            return tokenFromUserDefault
        }
    }
}
