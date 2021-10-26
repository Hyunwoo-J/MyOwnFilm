//
//  LoginResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


struct LoginResponse: Codable, CommonResponseType, CommonAccountResponseType {
    var code: Int
    var message: String?
    var userId: String?
    var token: String?
}
