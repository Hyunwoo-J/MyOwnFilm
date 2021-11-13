//
//  IntroViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/28.
//

import KeychainSwift
import UIKit


/// 인트로 화면
class IntroViewController: CommonViewController {
    
    /// 저장된 토큰을 확인합니다.
    ///
    /// 유효한 토큰일 경우, 메인 화면으로 이동합니다.
    /// 유효한 토큰이 아닐 경우, 로그인 화면으로 이동합니다.
    func validateToken() {
        guard let url = URL(string: "https://mofapi.azurewebsites.net/validation") else {
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = KeychainSwift().get(AccountKeys.apiToken.rawValue) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        let task = session.dataTask(with: request) { data, response, error in
            if let code = (response as? HTTPURLResponse)?.statusCode, code == 200 {
                self.goToMain()
            } else {
                self.goToLogin()
            }
        }
        task.resume()
    }
    
    
    /// 로그인 화면으로 이동합니다.
    private func goToLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 저장된 토큰이 있을 경우, 토큰을 검증하는 메소드를 실행합니다.
    /// 저장된 토큰이 없을 경우, 로그인 화면으로 이동합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = KeychainSwift().get(AccountKeys.userId.rawValue),
           let _ = KeychainSwift().get(AccountKeys.apiToken.rawValue) {
            validateToken()
        } else {
            goToLogin()
        }
    }
}
