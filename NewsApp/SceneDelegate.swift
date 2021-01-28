//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Renê Xavier on 24/01/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    // created so it won`t loose the refence of the coordinator
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        appCoordinator = AppCoordinator(window: window)
        self.window = window
        appCoordinator?.start()
    }
}
