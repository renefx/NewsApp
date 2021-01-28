//
//  UIViewController+Extension.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: Present Error
    func presentDefaultAlert(title: String = Constants.atencao, message: String?, _ handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertvc = UIAlertController(title: title,
                                        message: message ?? Constants.unknownError,
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.ok,
                                   style: .default,
                                   handler: handler)
        alertvc.addAction(action)
        self.present(alertvc, animated: true, completion: nil)
    }
    
    func presentDefaultAlert(_ message: DefaultServerError?, _ handler: ((UIAlertAction) -> Void)? = nil) {
        if message == nil {
            let alert = DefaultServerError(message: Constants.unknownError, statusCode: -9999)
            self.presentDefaultAlert(message: alert.messageUser, handler)
            return
        }
        self.presentDefaultAlert(message: message?.messageUser, handler)
    }
    
    func presentDefaultError(_ message: String?, _ handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertvc = UIAlertController(title: Constants.erro,
                                        message: message ?? Constants.unknownError,
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.ok,
                                   style: .default,
                                   handler: handler)
        alertvc.addAction(action)
        self.present(alertvc, animated: true, completion: nil)
    }
    
    func presentDefaultError(_ message: DefaultServerError?, _ handler: ((UIAlertAction) -> Void)? = nil) {
        self.presentDefaultError(message?.messageUser, handler)
    }
}
