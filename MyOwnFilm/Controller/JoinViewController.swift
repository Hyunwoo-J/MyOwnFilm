//
//  JoinViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import NSObject_Rx
import RxSwift
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
        
        let joinData = EmailJoinPostData(email: email, password: password)
        
        LoginDataManager.shared.singup(emailJoinPostData: joinData)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        LoginDataManager.shared.saveAccount(responseData: response)
                        self.showAlertMessage(message: "회원가입에 성공하였습니다.")
                    case ResultCode.fail.rawValue:
                        self.showAlertMessage(message: response.message ?? "오류가 발생했습니다.")
                    default:
                        break
                    }
                    
                case .failure(let error):
                    self.showAlertMessage(message: error.localizedDescription)
                }
            }
            .disposed(by: rx.disposeBag)
    }
}
