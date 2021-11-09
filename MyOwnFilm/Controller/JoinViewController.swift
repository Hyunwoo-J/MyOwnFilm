//
//  JoinViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import UIKit


/// 회원가입 화면
class JoinViewController: CommonViewController {
    
    /// 이메일 필드
    @IBOutlet weak var emailField: UITextField!
    
    /// 비밀번호 필드
    @IBOutlet weak var passwordField: UITextField!
    
    
    /// 이전 화면으로 돌아갑니다.
    /// - Parameter sender: X 버튼
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 이메일과 비밀번호를 가지고 회원가입합니다.
    /// - Parameter sender: 회원가입 버튼
    @IBAction func signup(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        guard let url = URL(string: "https://mofapi.azurewebsites.net/join/email") else { return }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let joinData = EmailJoinPostData(email: email, password: password)
            
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(joinData)
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
                        self.alertMessageWithHandler(message: "회원가입에 성공하였습니다.") { _ in
                            self.dismiss(animated: true, completion: nil)
                        }
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
}
