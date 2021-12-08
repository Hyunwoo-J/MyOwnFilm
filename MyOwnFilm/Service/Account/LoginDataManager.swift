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
    
    /// 싱글톤 인스턴스
    static let shared = LoginDataManager()
    private init() { }
    
    /// 로그인 키체인 인스턴스
    private let loginKeychain = KeychainSwift()
    
    /// 네트워크 서비스 객체
    ///
    /// Bearer 토큰 인증 방식을 사용합니다.
    private lazy var provider: MoyaProvider<LoginAndMovieReviewService> = {
        let token = loginKeychain.get(AccountKeys.apiToken.rawValue) ?? ""
        let authPlugin = AccessTokenPlugin { _ in token }
        
        return MoyaProvider<LoginAndMovieReviewService>(plugins: [authPlugin])
    }()
    
    
    /// 입력한 정보로 회원가입합니다.
    /// - Parameters:
    ///   - emailJoinPostData: 회원가입 정보를 담은 객체
    ///   - vc: 메소드를 호출하는 뷰컨트롤러
    func singup(emailJoinPostData: EmailJoinPostData) -> PrimitiveSequence<SingleTrait, JoinResponse> {
        provider.rx
            .request(.signup(emailJoinPostData))
            .map(JoinResponse.self)
            .retry(20)
    }
    
    
    /// 이메일과 비밀번호로 로그인합니다.
    /// - Parameters:
    ///   - emailLoginPostData: 로그인 정보를 담은 객체
    ///   - vc: 메소드를 호출하는 뷰컨트롤러
    func login(emailLoginPostData: EmailLoginPostData) -> PrimitiveSequence<SingleTrait, LoginResponse> {
        provider.rx
            .request(.login(emailLoginPostData))
            .map(LoginResponse.self)
            .retry(20)
    }
    
    
    /// 저장된 토큰을 확인합니다.
    ///
    /// 유효한 토큰일 경우, 메인 화면으로 이동합니다.
    /// 유효한 토큰이 아닐 경우, 로그인 화면으로 이동합니다.
    /// - Parameter vc: 메소드를 호출하는 뷰컨트롤러
    func validateToken() -> Single<Response> {
        provider.rx
            .request(.validateToken)
            .retry(20)
    }
    
    
    /// 계정 정보를 저장합니다.
    /// - Parameter responseData: 계정 응답 데이터 객체
    func saveAccount(responseData: CommonAccountResponseType) {
        if let userId = responseData.userId, let token = responseData.token {
            loginKeychain.set(userId, forKey: AccountKeys.userId.rawValue, withAccess: .accessibleAfterFirstUnlock)
            loginKeychain.set(token, forKey: AccountKeys.apiToken.rawValue, withAccess: .accessibleAfterFirstUnlock)
            loginKeychain.set("email", forKey: AccountKeys.provider.rawValue, withAccess: .accessibleAfterFirstUnlock)
        }
    }
}
