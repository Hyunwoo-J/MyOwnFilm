//
//  String+Fomatter.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/19.
//

import Foundation


fileprivate let formatter = DateFormatter()



extension String {
    
    /// 관리자가 사용하는 날짜 형식으로 날짜를 변환합니다.
    /// - Returns: 날짜
    func toManagerDBDate() -> Date {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        return formatter.date(from: self) ?? Date()
    }
    
    
    /// 관리자가 사용하는 날짜 형식으로 날짜를 변환합니다.
    /// - Returns: 날짜
    func toManagerDate() -> Date? {
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "ko_kr")
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    
    /// 관리자가 사용하는 날짜 형식으로 날짜를 변환합니다.
    /// - Returns: 날짜
    func toManagerMemoDate() -> Date? {
        formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "ko_kr")
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
