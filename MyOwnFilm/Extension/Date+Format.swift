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
        formatter.dateFormat = "yyyy-M-d"
        
        return formatter.string(from: self)
    }
}



extension String {
    var userDate: String? {
        let dateComp = self.components(separatedBy: "-")
        guard dateComp.count == 3 else { return nil}
        
        let year = dateComp[0]
        let month = dateComp[1]
        let day = dateComp[2]
        
        return "\(year)년 \(month)월 \(day)일"
    }
}
