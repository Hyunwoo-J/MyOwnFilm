//
//  NaverResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


struct NaverResponse: Codable {
    struct Response: Codable {
        let id: String
        let email: String
    }
    
    let resultcode: String
    let message: String
    let response: Response
}
