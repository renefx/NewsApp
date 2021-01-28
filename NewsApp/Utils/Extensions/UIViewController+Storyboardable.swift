//
//  UIViewController+Storyboardable.swift
//  NewsApp
//
//  Created by Renê Xavier on 24/01/21.
//

import Foundation
import UIKit

public protocol Storyboardable {
    static var storyboardBundle: Bundle { get }
}

extension Storyboardable where Self: UIViewController {

    public static var storyboardBundle: Bundle {
        return Bundle(for: self)
    }
    
    public static var identifier: String {
        return String(describing: self)
    }
    
    public static func getBundle(forStoryboard storyboardName: String) -> Bundle? {
        // for cases like UINavigationController.instantiateInitial()
        if storyboardBundle.path(forResource: storyboardName, ofType: "storyboardc") == nil {
            if Bundle.main.path(forResource: storyboardName, ofType: "storyboardc") == nil {
                return nil
            }
            return Bundle.main
        }
        return storyboardBundle
    }
}

extension ViewModelBased where Self: UIViewController {
    
    static func instantiate(from storyboardName: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        guard let viewcontroller = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Could not instantiate viewcontroller \(identifier) in storyboard with name: \(storyboardName)")
        }
        return viewcontroller
    }
    
    static func instantiateInitial() -> Self {
        let storyboardName = self.identifier
        guard let bundle = getBundle(forStoryboard: storyboardName),
            let viewcontroller = UIStoryboard(name: storyboardName, bundle: bundle).instantiateInitialViewController() as? Self else {
            fatalError("Could not instantiate initial storyboard for: \(storyboardName)")
        }
        return viewcontroller
    }
}

extension UIViewController: Storyboardable {}

