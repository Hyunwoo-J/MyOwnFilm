//
//  AccountKeys.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/28.
//

import Foundation


/// 계정 키
///
/// 키 중복을 방지하기 위해 만들었습니다.
enum AccountKeys: String {
    case provider = "com.hyunwooJang.MyOwnFilm.provider"
    case userId = "com.hyunwooJang.MyOwnFilm.userId"
    case apiToken = "com.hyunwooJang.MyOwnFilm.apiToken"
    case name = "com.hyunwooJang.MyOwnFilm.name"
}
