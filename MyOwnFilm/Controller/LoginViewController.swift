//
//  FirstViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/06/10.
//

import NSObject_Rx
import RxSwift
import UIKit


/// 로그인 화면
class LoginViewController: CommonViewController {
    
    /// 이메일 필드
    @IBOutlet weak var emailField: UITextField!
    
    /// 비밀번호 필드
    @IBOutlet weak var passwordField: UITextField!
    
    
    /// 이메일과 비밀번호로 로그인합니다.
    ///
    /// 로그인에 성공할 경우, 메인 화면으로 이동합니다.
    /// 로그인에 실패할 경우, 경고창을 띄웁니다.
    /// - Parameter sender: 버튼
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        let loginData = EmailLoginPostData(email: email, password: password)
        
        LoginDataManager.shared.login(emailLoginPostData: loginData)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        LoginDataManager.shared.saveAccount(responseData: response)
                        self.goToMain()
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
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        emailField.text = "test777@test.com"
        passwordField.text = "Test123456#"
        #endif
    }
}
