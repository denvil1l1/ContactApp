//
//  SceneDelegate.swift
//  Contacts App
//
//  Created by Vladislav on 12.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let vc = ContactListController()
            let navController = UINavigationController(rootViewController: vc)
            guard let windowScene = (scene as? UIWindowScene) else {return}
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
    }
    
}
