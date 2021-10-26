//
//  SignUpViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import FBSDKCoreKit
import FBSDKLoginKit
import UIKit


/// 회원 가입 화면
class SignUpViewController: CommonViewController {
    
    /// 페이스북 로그인 매니저
    let manager = LoginManager()
    
    
    /// 페이스북 계정으로 로그인합니다.
    /// - Parameter sender: 페이스북 버튼
    @IBAction func loginWithFacebook(_ sender: Any) {
        manager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            if let error = error {
                print(error)
                
                return
            }
            
            if let result = result {
                if result.isCancelled {
                    print("사용자가 취소함")
                } else {
                    if let _ = AccessToken.current {
                        print("페이스북 로그인 성공")
                        self.getFacebookProfile()
                        self.goToMain()
                    } else {
                        print("페이스북 로그인 실패")
                    }
                }
            }
        }
    }
    
    
    /// 페이스북 프로필을 가져옵니다.
    private func getFacebookProfile() {
        guard let token = AccessToken.current, !token.isExpired else {
            return
        }
        
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        request.start { connection, result, error in
            if let error = error {
                print(error)
                
                return
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
