//
//  SignUpViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import NaverThirdPartyLogin
import UIKit


/// 회원 가입 화면
class SignupViewController: CommonViewController {
    
    /// 페이스북 로그인 매니저
    let manager = LoginManager()
    
    
    @available(iOS 13.0, *)
    @IBAction func signupwithApple(_ sender: Any) {
        let idProvider = ASAuthorizationAppleIDProvider()
        let request = idProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
    /// 네이버로 회원가입을 하고 로그인합니다.
    /// - Parameter sender: 네이버 버튼
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
    
    
    /// 네이버 프로필을 가져옵니다.
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
    
    
    /// 카카오로 회원가입을 하고 로그인합니다.
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
    
    
    /// 페이스북 계정으로 회원가입을 하고 로그인합니다.
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



@available(iOS 13.0, *)
extension SignupViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}



@available(iOS 13.0, *)
extension SignupViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        alertMessage(message: error.localizedDescription)
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = credential.user
            var email = credential.email
            let _ = credential.identityToken
            var name = credential.fullName?.givenName // 이름
            
            if let email = email, email.count > 0 {
                UserDefaults.standard.set(email, forKey: "email")
            } else {
                email = UserDefaults.standard.string(forKey: "email") ?? ""
            }
            
            if let name = name, name.count > 0 {
                UserDefaults.standard.set(name, forKey: "name")
            } else {
                name = UserDefaults.standard.string(forKey: "name")
            }
            
            let postData = SocialLoginPostData(provider: "Apple", id: userId, email: email ?? "")
            self.login(data: postData)
        }
    }
}



extension SignupViewController: NaverThirdPartyLoginConnectionDelegate {
    
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
