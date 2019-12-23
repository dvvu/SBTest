//
//  UseCaseProvider.swift
//  Application
//
//  Created by Vu Doan on 12/18/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation

protocol UseCaseProvider {
    func makeMovieUseCase() -> MovieUseCase
}
