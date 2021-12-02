//
//  ReviewManager.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/26.
//

import Moya
import KeychainSwift
import RxSwift
import UIKit


extension Notification.Name {
    /// 새로운 리뷰를 저장할 때 보낼 노티피케이션
    static let reviewDidSaved = Notification.Name(rawValue: "reviewDidSaved")
    
    /// 리뷰를 업데이트할 때 보낼 노티피케이션
    static let reviewDidUpdate = Notification.Name(rawValue: "reviewDidUpdate")
}



/// 영화 리뷰 데이터 관리
class ReviewDataManager {
    
    /// 싱글톤
    static let shared = ReviewDataManager()
    
    /// 싱글톤
    private init() { }
    
    /// 리뷰 목록
    var reviewList = [ReviewList.Review]()
    
    /// 로그인 키체인 인스턴스
    let loginKeychain = KeychainSwift()
    
    /// ISO8601DateFormatter
    ///
    /// 데이터를 POST 할 때 사용하기 위해서 만들었습니다.
    let postDateFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        return f
    }()
    
    /// 네트워크 서비스 객체
    ///
    /// Bearer 토큰 인증 방식을 사용합니다.
    lazy var provider: MoyaProvider<Service> = {
        let token = loginKeychain.get(AccountKeys.apiToken.rawValue) ?? ""
        let authPlugin = AccessTokenPlugin { _ in token }
        
        return MoyaProvider<Service>(plugins: [authPlugin])
    }()
    
    
    /// 작성한 영화 리뷰를 다운로드합니다.
    /// - Parameter completion: 완료 블록
    func fetchReview(completion: @escaping () -> ()) {
        provider.request(.reviewList) { result in
            switch result {
            case .success(let response):
                self.reviewList = ReviewList.parse(data: response.data)
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription) // 경고창 알 수 없는 오류(네트워크 오류) -> 고객센터
            }
        }
    }
    
    
    /// 영화 리뷰를 삭제합니다.
    /// - Parameters:
    ///   - id: 리뷰 ID
    ///   - completion: 완료 블록
    func deleteReview(id: Int, completion: @escaping () -> ()) {
        provider.request(.removeReview(id)) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /// 영화 리뷰를 저장합니다.
    /// - Parameter reviewPostData: 저장할 리뷰 데이터
    func saveReview(reviewPostData: ReviewPostData) {
        provider.request(.saveReview(reviewPostData)) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .reviewDidSaved, object: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /// 영화 리뷰를 수정합니다.
    /// - Parameter reviewPutData: 수정된 리뷰 데이터
    func editReview(reviewPutData: ReviewPutData) {
        provider.request(.editReview(reviewPutData)) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .reviewDidUpdate, object: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
}
