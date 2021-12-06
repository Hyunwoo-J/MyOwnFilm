//
//  MovieTheaterData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


/// 영화관 정보 모델
///
/// 서버에서 데이터를 받아오기 위해 정의한 모델입니다.
struct MovieTheaterData: Codable {
    
    /// 영화관 정보 모델
    struct MovieTheater: Codable {
        
        /// 영화관 ID
        let movieTheaterId: Int
        
        /// 광역단체
        let metropolitanCouncil: String
        
        /// 기초단체
        let basicOrganization: String
        
        /// 영화관 이름
        let name: String
    }
    
    /// 영화관 목록
    let list: [MovieTheater]
    
    /// 응답 코드
    let code: Int
    
    /// 메시지
    let message: String?
    
    
    /// 영화관 데이터를 파싱합니다.
    /// - Parameters:
    ///   - data: 영화관 데이터
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    /// - Returns: 영화관 목록
    static func parse(data: Data, vc: CommonViewController) -> [MovieTheater] {
        var list = [MovieTheater]()
        
        do {
            let decoder = JSONDecoder()
            let movieTheaterData = try decoder.decode(MovieTheaterData.self, from: data)
            
            if movieTheaterData.code == ResultCode.ok.rawValue {
                list = movieTheaterData.list
            }
        } catch {
            vc.showAlertMessage(message: error.localizedDescription)
        }
        
        return list
    }
}
