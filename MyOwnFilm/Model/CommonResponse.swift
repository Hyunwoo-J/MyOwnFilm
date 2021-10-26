//
//  CommonResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


protocol CommonResponseType {
    var code: Int { get }
    var message: String? { get }
}



protocol CommonAccountResponseType {
    var userId: String? { get }
    var token: String? { get }
}



/// 서버 응답
struct CommonResponse: Codable, CommonResponseType {
    let code: Int
    let message: String?
}
