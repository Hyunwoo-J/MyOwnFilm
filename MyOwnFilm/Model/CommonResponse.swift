//
//  CommonResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


/// 서버 응답
struct CommonResponse: Codable {
    let resultCode: Int
    let message: String?
}
