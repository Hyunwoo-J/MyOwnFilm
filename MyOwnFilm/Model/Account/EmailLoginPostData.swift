//
//  EmailLoginPostData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


/// 이메일 로그인 POST 모델
struct EmailLoginPostData: Codable {
    
    /// 이메일
    let email: String
    
    /// 비밀번호
    let password: String
}
