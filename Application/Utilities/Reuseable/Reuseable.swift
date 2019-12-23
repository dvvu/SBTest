//
//  Reuseable.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}

extension UICollectionViewCell: Reusable {}

extension UIViewController: Reusable {}

extension UITableView {
    func dequeueReusableCell<T: Reusable>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    func dequeueReusableCell<T: Reusable>(ofType cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID) as? T else {
            fatalError()
        }
        return cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: Reusable>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    func dequeueReusableHeader<T: Reusable>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T {
        let headerCell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                          withReuseIdentifier: cellType.reuseID,
                                                          for: indexPath)
        guard let cell = headerCell as? T else {
            fatalError()
        }
        return cell
    }
    
    func dequeueReusableFooter<T: Reusable>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T {
        let footerCell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                          withReuseIdentifier: cellType.reuseID,
                                                          for: indexPath)
        guard let cell = footerCell as? T else {
            fatalError()
        }
        return cell
    }
}

extension UIStoryboard {
    func instantiateViewController<T: Reusable>(ofType type: T.Type = T.self) -> T {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseID) as? T else {
            fatalError()
        }
        return viewController
    }
}
