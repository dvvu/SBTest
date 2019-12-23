//
//  UIViewController+Extension.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

extension UIViewController {
    var indicator: Binder<Bool> {
        return Binder(self) { (vc, loading) in
            if loading {
                let maskView = UIView(frame: vc.view.bounds)
                maskView.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
                maskView.tag = 999
                
                let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                indicator.startAnimating()
                indicator.translatesAutoresizingMaskIntoConstraints = false
                
                maskView.addSubview(indicator)
                
                let maskViewMargins = maskView.layoutMarginsGuide
                indicator.centerXAnchor.constraint(equalTo: maskViewMargins.centerXAnchor).isActive = true
                indicator.centerYAnchor.constraint(equalTo: maskViewMargins.centerYAnchor).isActive = true
                
                vc.view.addSubview(maskView)
                maskView.snp.makeConstraints { (make) -> Void in
                    make.edges.equalTo(self.view)
                }
            } else {
                DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5, execute: {
                    vc.view.viewWithTag(999)?.removeFromSuperview()
                })
            }
        }
    }
}
