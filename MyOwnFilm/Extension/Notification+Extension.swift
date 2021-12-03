//
//  Notification+Extension.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/12/04.
//

import Foundation


extension Notification.Name {
    
    /// 새로운 리뷰를 저장할 때 보낼 노티피케이션
    static let reviewDidSaved = Notification.Name(rawValue: "reviewDidSaved")
    
    /// 리뷰를 업데이트할 때 보낼 노티피케이션
    static let reviewDidUpdate = Notification.Name(rawValue: "reviewDidUpdate")
    
    /// 리뷰 작성이 취소되면 보낼 노티피케이션
    static let reviewWillCancelled = Notification.Name(rawValue: "reviewWillCancelled")
    
    /// 영화 목록 테이블뷰 셀이 선택되면 보낼 노티피케이션
    static let movieTheaterTableViewCellDidTapped = Notification.Name(rawValue: "movieTheaterTableViewCellDidTapped")
    
    /// 메모 확인 버튼을 누르면 보낼 노티피케이션
    static let memoDidSaved = Notification.Name(rawValue: "memoDidSaved")
}
