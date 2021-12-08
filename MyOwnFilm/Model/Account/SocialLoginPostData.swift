//
//  SocialLoginPostData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


/// SNS 로그인 POST 모델
struct SocialLoginPostData: Codable {
    
    /// 공급자
    let provider: String
    
    /// 아이디
    let id: String
    
    /// 이메일
    let email: String
}
