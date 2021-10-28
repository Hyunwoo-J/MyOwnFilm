//
//  FirstViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/06/10.
//

import UIKit


/// 로그인 화면
class LoginViewController: CommonViewController {
    
    /// 이메일 필드
    @IBOutlet weak var emailField: UITextField!
    
    /// 패스워드 필드
    @IBOutlet weak var passwordField: UITextField!
    
    
    /// 버튼을 누르면 다음 화면으로 이동합니다.
    /// - Parameter sender: 버튼
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        guard let url = URL(string: "https://mofapi.azurewebsites.net/login/email") else { return }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let loginData = EmailLoginPostData(email: email, password: password)
            
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(loginData)
        } catch {
            print(error)
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let apiResponse = try decoder.decode(LoginResponse.self, from: data)
                    
                    switch apiResponse.code {
                    case ResultCode.ok.rawValue:
                        self.saveAccount(responseData: apiResponse)
                        self.goToMain()
                    case ResultCode.fail.rawValue:
                        self.alertMessage(message: apiResponse.message ?? "오류가 발생했습니다.")
                    default:
                        break
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        emailField.text = "test777@test.com"
        passwordField.text = "Test123456#"
        #endif
    }
}
