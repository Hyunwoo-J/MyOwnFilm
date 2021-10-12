//
//  CommonResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


struct CommonResponse: Codable {
    let resultCode: Int
    let message: String?
}
