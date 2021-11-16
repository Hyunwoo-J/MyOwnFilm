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
import KeychainSwift
import NaverThirdPartyLogin
import UIKit



/// 회원가입 화면
class SignupViewController: CommonViewController {
    
    /// 페이스북 로그인 매니저
    let manager = LoginManager()
    
    
    @available(iOS 13.0, *)
    /// 애플로 회원가입하고 로그인합니다.
    /// - Parameter sender: 애플 회원가입 버튼
    @IBAction func signupWithApple(_ sender: Any) {
        let idProvider = ASAuthorizationAppleIDProvider()
        let request = idProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
    /// 네이버로 회원가입하고 로그인합니다.
    /// - Parameter sender: 네이버 회원가입 버튼
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
    
    
    /// 네이버 프로필 정보를 가져옵니다.
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
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                self.showAlertMessage(message: error.localizedDescription)
                
                return
            }
            
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
                    self.showAlertMessage(message: error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    /// 카카오로 회원가입하고 로그인합니다.
    /// - Parameter sender: 카카오 회원가입 버튼
    @IBAction func signupWithKakao(_ sender: Any) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                self.showAlertMessage(message: error.localizedDescription)
                
                return
            }
            
            else {
                #if DEBUG
                print("loginWithKakaoAccount() success.")
                #endif
                
                if let _ = oauthToken {
                    if (AuthApi.hasToken()) {
                        UserApi.shared.accessTokenInfo { (_, error) in
                            if let error = error {
                                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                                    self.showAlertMessage(message: sdkError.localizedDescription)
                                }
                                else {
                                    self.showAlertMessage(message: "카카오에 로그인 할 수 없습니다.")
                                }
                            }
                            else {
                                #if DEBUG
                                print("토큰 유효성 체크 성공(필요 시 토큰 갱신됨)")
                                #endif
                                
                                UserApi.shared.me() {(user, error) in
                                    if let error = error {
                                        self.showAlertMessage(message: error.localizedDescription)
                                    }
                                    else {
                                        #if DEBUG
                                        print("me() success.")
                                        #endif
                                        
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
                        self.showAlertMessage(message: "로그인이 만료되었습니다. 다시 로그인 해 주세요.")
                    }
                }
            }
        }
    }
    
    
    /// 페이스북으로 회원가입하고 로그인합니다.
    /// - Parameter sender: 페이스북 회원가입 버튼
    @IBAction func signupWithFacebook(_ sender: Any) {
        manager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            if let error = error {
                self.showAlertMessage(message: error.localizedDescription)
                
                return
            }
            
            if let result = result {
                if result.isCancelled {
                    #if DEBUG
                    print("사용자가 취소함")
                    #endif
                } else {
                    if let _ = AccessToken.current {
                        #if DEBUG
                        print("페이스북 로그인 성공")
                        #endif
                        
                        self.getFacebookProfile()
                        self.goToMain()
                    } else {
                        #if DEBUG
                        print("페이스북 로그인 실패")
                        #endif
                    }
                }
            }
        }
    }
    
    
    /// 페이스북 프로필 정보를 가져옵니다.
    private func getFacebookProfile() {
        guard let token = AccessToken.current, !token.isExpired else {
            return
        }
        
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        request.start { connection, result, error in
            if let error = error {
                self.showAlertMessage(message: error.localizedDescription)
                
                return
            }
        }
    }
    
    
    /// SNS로 로그인합니다.
    /// - Parameter data: 카카오, 네이버 로그인 데이터
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
            self.showAlertMessage(message: error.localizedDescription)
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.showAlertMessage(message: error.localizedDescription)
                
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
                        self.showAlertMessage(message: apiResponse.message ?? "오류가 발생했습니다.")
                    default:
                        break
                    }
                } catch {
                    self.showAlertMessage(message: error.localizedDescription)
                }
            }
        }.resume()
    }
}



@available(iOS 13.0, *)
/// 애플 로그인 기능 구현
extension SignupViewController: ASAuthorizationControllerPresentationContextProviding {
    
    /// 현재 뷰의 윈도우를 리턴합니다.
    /// - Parameter controller: SignupViewController
    /// - Returns: ASPresentationAnchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}



@available(iOS 13.0, *)
/// 애플 로그인 기능 구현
extension SignupViewController: ASAuthorizationControllerDelegate {
    
    /// 애플 로그인에 실패하면 경고 메시지를 출력합니다.
    /// - Parameters:
    ///   - controller: SignupViewController
    ///   - error: An error that explains the failure using one of the codes in ASAuthorizationError.Code.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showAlertMessage(message: error.localizedDescription)
    }
    
    
    /// 애플 로그인에 성공하면 유저 정보에 이메일과 이름을 저장합니다.
    /// - Parameters:
    ///   - controller: SignupViewController
    ///   - authorization: An encapsulation of the successful authorization.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = credential.user
            var email = credential.email
            let _ = credential.identityToken
            var name = credential.fullName?.givenName
            
            if let email = email, email.count > 0 {
                loginKeychain.set(email, forKey: AccountKeys.provider.rawValue, withAccess: .accessibleAfterFirstUnlock)
            } else {
                email = loginKeychain.get(AccountKeys.provider.rawValue) ?? ""
            }
            
            if let name = name, name.count > 0 {
                loginKeychain.set(name, forKey: AccountKeys.name.rawValue, withAccess: .accessibleAfterFirstUnlock)
            } else {
                name = loginKeychain.get(AccountKeys.name.rawValue) ?? ""
            }
            
            let postData = SocialLoginPostData(provider: "Apple", id: userId, email: email ?? "")
            self.login(data: postData)
        }
    }
}



/// 네이버 로그인 기능 구현
extension SignupViewController: NaverThirdPartyLoginConnectionDelegate {
    
    /// 네이버 로그인에 성공했을 경우, 프로필 정보를 가져옵니다.
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverProfile()
    }
    
    
    /// 접근 토큰이 갱신됐을 경우, 네이버 프로필 정보를 가져옵니다.
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        getNaverProfile()
    }
    
    
    /// 토큰을 삭제하면 호출됩니다.
    func oauth20ConnectionDidFinishDeleteToken() {
    }
    
    
    /// 에러가 발생했을 경우 호출됩니다.
    /// - Parameters:
    ///   - oauthConnection: NaverThirdPartyLoginConnection
    ///   - error: 에러
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        showAlertMessage(message: error.localizedDescription)
    }
}
