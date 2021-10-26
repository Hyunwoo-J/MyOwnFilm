//
//  SocialLoginPostData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


struct SocialLoginPostData: Codable {
    let provider: String
    let id: String
    let email: String
}
