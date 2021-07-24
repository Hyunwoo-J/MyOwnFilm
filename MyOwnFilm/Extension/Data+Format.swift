//
//  Data+Format.swift
//  Data+Format
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import Foundation

import Foundation

fileprivate let formatter = DateFormatter()

extension Date {
    var releaseDate: String {
        formatter.dateFormat = "yyyy-M-d"
        
        return formatter.string(from: self)
    }
}


extension Int {
    var day: TimeInterval {
        return TimeInterval(60 * 60 * 24)
    }
}
