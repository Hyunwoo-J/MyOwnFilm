//
//  SignUpViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import FBSDKCoreKit
import FBSDKLoginKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import NaverThirdPartyLogin
import UIKit


/// 회원 가입 화면
class SignUpViewController: CommonViewController {
    
    /// 페이스북 로그인 매니저
    let manager = LoginManager()
    
    
    /// 페이스북 계정으로 로그인합니다.
    /// - Parameter sender: 페이스북 버튼
    @IBAction func signupWithFacebook(_ sender: Any) {
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
    
    
    /// 카카오로 로그인합니다.
    /// - Parameter sender: 카카오 버튼
    @IBAction func signupWithKakao(_ sender: Any) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            
            else {
                print("loginWithKakaoAccount() success.")
                
                if let _ = oauthToken {
                    if (AuthApi.hasToken()) {
                        UserApi.shared.accessTokenInfo { (_, error) in
                            if let error = error {
                                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                                    self.alertMessage(message: sdkError.localizedDescription)
                                }
                                else {
                                    self.alertMessage(message: "카카오에 로그인 할 수 없습니다.")
                                }
                            }
                            else {
                                print("토큰 유효성 체크 성공(필요 시 토큰 갱신됨)")
                                
                                UserApi.shared.me() {(user, error) in
                                    if let error = error {
                                        print(error)
                                    }
                                    else {
                                        print("me() success.")
                                        
                                        if let user = user, let id = user.id, let email = user.kakaoAccount?.email {
                                            let data = SocialLoginPostData(provider: "KakaoTalk", id: "\(id)", email: email)
                                            self.login(data: data)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        self.alertMessage(message: "로그인이 만료되었습니다. 다시 로그인 해 주세요.")
                    }
                }
            }
        }
    }
    
    
    @IBAction func signupWithNaver(_ sender: Any) {
        if let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance() {
            if let _ = naverLogin.accessToken {
                getNaverProfile()
                
                return
            }
            
            naverLogin.delegate = self
            naverLogin.requestThirdPartyLogin()
        }
    }
    
    private func getNaverProfile() {
        guard let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        guard let token = naverLogin.accessToken else { return }
        
        let apiURL = "https://openapi.naver.com/v1/nid/me"
        guard let url = URL(string: apiURL) else { return }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.setValue("w9eehqWBlY_oheYT0Umv", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("2EyfP25Rdb", forHTTPHeaderField: "X-Naver-Client-Secret")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let apiResponse = try decoder.decode(NaverResponse.self, from: data)
                    
                    let id = apiResponse.response.id
                    let email = apiResponse.response.email
                    let data = SocialLoginPostData(provider: "Naver", id: id, email: email)
                    
                    switch apiResponse.resultcode {
                    case "00":
                        self.login(data: data)
                    default:
                        break
                    }
                } catch {
                    self.alertMessage(message: error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    private func login(data: SocialLoginPostData) {
        guard let url = URL(string: "https://mofapi.azurewebsites.net/login/sso") else {
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(data)
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
        
    }
}



extension SignUpViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverProfile()
    }
    
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        getNaverProfile()
    }
    
    
    func oauth20ConnectionDidFinishDeleteToken() {
    }
    
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        alertMessage(message: error.localizedDescription)
    }
}
