//
//  Data+Format.swift
//  Data+Format
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import Foundation


fileprivate let formatter = DateFormatter()



extension Date {
    /// Api에서 내려오는 날짜 형식으로 변환
    var releaseDate: String {
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
    
    
    /// 리뷰를 남기는 유저 화면에 표시할 날짜 형식으로 변환합니다.
    /// - Returns: 변환된 날짜 문자열
    func toUserDateString() -> String {
        formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
    
    
    /// 기본 영화 정보를 표시할 때 사용하는 날짜 형식으로 변환합니다.
    /// - Returns: 변환된 날짜 문자열
    func toUserDateStringForMovieData() -> String {
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
}
