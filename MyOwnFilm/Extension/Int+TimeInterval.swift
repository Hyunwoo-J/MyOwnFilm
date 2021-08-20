//
//  Int+TimeInterval.swift
//  Int+TimeInterval
//
//  Created by Hyunwoo Jang on 2021/08/20.
//

import Foundation

extension Int {
    /// TimeInterval로 계산해서 일자를 반환
    var day: TimeInterval {
        return TimeInterval(60 * 60 * 24)
    }
}
