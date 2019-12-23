//
//  RxUtils.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RxUtils {
    class func commonError() -> Observable<Void> {
        return RxUtils.alert(title: "Lỗi", text: "Có lỗi Xảy ra", dismissTitle: "Đồng ý")
    }
    
    // create more func if need.. Please don't change func because someone can get error.
    class func alert(title: String, text: String? = nil, dismissTitle: String = "Đóng") -> Observable<Void> {
        return Observable.create { observer in
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: dismissTitle, style: .default) { _ in
                observer.onNext(())
                observer.onCompleted()
            })
            rootViewController.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                dismissViewController(alertVC, animated: true)
            }
        }
    }
    
    class func confirmAlert(title: String, message: String? = nil, confirmTitle: String = "Đóng", dismissTitle: String = "Cancel") -> Observable<Bool> {
        
        if let message = message {
            let attributedMessage = NSAttributedString(string: message)
            return RxUtils.confirmAlert(title: title, attributedMessage: attributedMessage, confirmTitle: confirmTitle, dismissTitle: dismissTitle)
        } else {
            return RxUtils.confirmAlert(title: title, attributedMessage: nil, confirmTitle: confirmTitle, dismissTitle: dismissTitle)
        }
    }
    
    class func confirmAlert(title: String, attributedMessage: NSAttributedString? = nil, confirmTitle: String, dismissTitle: String) -> Observable<Bool> {
        return Observable.create { observer in
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let alertVC = UIAlertController(title: title, message: "", preferredStyle: .alert)
            alertVC.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                observer.onNext(true)
                observer.onCompleted()
            }
            let cancelAction = UIAlertAction(title: dismissTitle, style: .cancel) { _ in
                observer.onNext(false)
                observer.onCompleted()
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            
            rootViewController.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                dismissViewController(alertVC, animated: true)
            }
        }
    }
    
}

fileprivate func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}
