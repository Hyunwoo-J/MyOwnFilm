//
//  ReplaceRootSegue.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import UIKit


/// 커스텀 Segue
///
/// 로그인 화면 전환에 사용하기 위해서 만들었습니다.
class ReplaceRootSegue: UIStoryboardSegue {
    
    /// Subclasses can override this method to augment or replace the effect of this segue.
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
