//
//  Data+Format.swift
//  Data+Format
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import Foundation


fileprivate let formatter = DateFormatter()



extension Date {
    /// 지정된 형식으로 날짜를 반환
    var releaseDate: String {
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
    
    func toUserDateString() -> String {
        formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
    
    func toUserDateStringForMovieData() -> String {
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
}



extension String {
    func toManagerDate() -> Date? {
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toManagerMemoDate() -> Date? {
        formatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
