//
//  ErrorResponse.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation

protocol ErrorResponse {
    var message: String? { get set }
    var statusCode: Int? { get set }
}

enum ErrorServer: Error {
    case tokenExpired
    case failed(code: Int?, message: String?)
}
