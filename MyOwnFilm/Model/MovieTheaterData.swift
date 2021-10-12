//
//  MovieTheaterData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


/// 서버에서 받아올 영화관 정보
struct MovieTheaterData: Codable {
    struct MovieTheater: Codable {
        let movieTheaterId: Int
        let metropolitanCouncil: String
        let basicOrganization: String
        let name: String
    }
    
    let list: [MovieTheater]
    let resultCode: Int
    let message: String?
}
