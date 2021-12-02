//
//  LoginDataManager.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/11/27.
//

import Foundation
import KeychainSwift
import Moya
import RxSwift


/// 로그인 데이터 관리
class LoginDataManager {
    
    /// 싱글톤
    static let shared = LoginDataManager()
    
    /// 싱글톤
    private init() { }
    
    /// 리소스 정리
    private let bag = DisposeBag()
    
    /// 로그인 키체인 인스턴스
    private let loginKeychain = KeychainSwift()
    
    /// 네트워크 서비스 객체
    ///
    /// Bearer 토큰 인증 방식을 사용합니다.
    private lazy var provider: MoyaProvider<Service> = {
        let token = loginKeychain.get(AccountKeys.apiToken.rawValue) ?? ""
        let authPlugin = AccessTokenPlugin { _ in token }
        
        return MoyaProvider<Service>(plugins: [authPlugin])
    }()
    
    
    /// 입력한 정보로 회원가입합니다.
    /// - Parameters:
    ///   - emailJoinPostData: 회원가입 정보를 담은 객체
    ///   - vc: 메소드를 호출하는 뷰컨트롤러
    func singup(emailJoinPostData: EmailJoinPostData, vc: CommonViewController) {
        provider.rx.request(.signup(emailJoinPostData))
            .map(JoinResponse.self)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        self.saveAccount(responseData: response)
                        vc.showAlertMessage(message: "회원가입에 성공하였습니다.")
                    case ResultCode.fail.rawValue:
                        vc.showAlertMessage(message: response.message ?? "오류가 발생했습니다.")
                    default:
                        break
                    }
                    
                case .failure(let error):
                    vc.showAlertMessage(message: error.localizedDescription)
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 이메일과 비밀번호로 로그인합니다.
    /// - Parameters:
    ///   - emailLoginPostData: 로그인 정보를 담은 객체
    ///   - vc: 메소드를 호출하는 뷰컨트롤러
    func login(emailLoginPostData: EmailLoginPostData, vc: CommonViewController) {
        provider.rx.request(.login(emailLoginPostData))
            .map(LoginResponse.self)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        self.saveAccount(responseData: response)
                        vc.goToMain()
                    case ResultCode.fail.rawValue:
                        vc.showAlertMessage(message: response.message ?? "오류가 발생했습니다.")
                    default:
                        break
                    }
                    
                case .failure(let error):
                    vc.showAlertMessage(message: error.localizedDescription)
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 저장된 토큰을 확인합니다.
    ///
    /// 유효한 토큰일 경우, 메인 화면으로 이동합니다.
    /// 유효한 토큰이 아닐 경우, 로그인 화면으로 이동합니다.
    /// - Parameter vc: 메소드를 호출하는 뷰컨트롤러
    func validateToken(vc: CommonViewController) {
        provider.rx.request(.validateToken)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case ResultCode.ok.rawValue:
                        vc.goToMain()
                    default:
                        vc.goToLogin()
                    }
                    
                case .failure(let error):
                    vc.showAlertMessage(message: error.localizedDescription)
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 계정 정보를 저장합니다.
    /// - Parameter responseData: 계정 응답 데이터 객체
    private func saveAccount(responseData: CommonAccountResponseType) {
        if let userId = responseData.userId, let token = responseData.token {
            loginKeychain.set(userId, forKey: AccountKeys.userId.rawValue, withAccess: .accessibleAfterFirstUnlock)
            loginKeychain.set(token, forKey: AccountKeys.apiToken.rawValue, withAccess: .accessibleAfterFirstUnlock)
            loginKeychain.set("email", forKey: AccountKeys.provider.rawValue, withAccess: .accessibleAfterFirstUnlock)
        }
    }
}
