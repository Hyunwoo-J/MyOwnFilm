//
//  ReplaceRootSegue.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import UIKit


/// <#Description#>
class ReplaceRootSegue: UIStoryboardSegue {
    
    /// <#Description#>
    override func perform() {
        var window: UIWindow?
        
        if #available(iOS 13, *) {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            
            window = sceneDelegate.window
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            window = appDelegate.window
        }
        
        window?.rootViewController?.view.removeFromSuperview()
        window?.rootViewController?.removeFromParent()
        
        window?.rootViewController = destination
        
        if let mainWindow = window {
            UIView.transition(with: mainWindow, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
}
