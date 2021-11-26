//
//  EmailJoinPostData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


/// 이메일 회원가입 POST 모델
struct EmailJoinPostData: Codable {
    
    /// 이메일
    let email: String
    
    /// 비밀번호
    let password: String
}
