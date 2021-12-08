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


/// 영화 리뷰 데이터 관리
class ReviewDataManager {
    
    /// 싱글톤 인스턴스
    static let shared = ReviewDataManager()
    private init() { }
    
    /// 리뷰 목록
    var reviewList = [ReviewList.Review]()
    
    /// 로그인 키체인 인스턴스
    private let loginKeychain = KeychainSwift()
    
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
    private lazy var provider: MoyaProvider<LoginAndMovieReviewService> = {
        let token = loginKeychain.get(AccountKeys.apiToken.rawValue) ?? ""
        let authPlugin = AccessTokenPlugin { _ in token }
        
        return MoyaProvider<LoginAndMovieReviewService>(plugins: [authPlugin])
    }()
    
    /// 리소스 정리
    private let bag = DisposeBag()
    
    
    /// 작성한 영화 리뷰를 다운로드합니다.
    /// - Parameters:
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func fetchReview(vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.reviewList) { result in
            switch result {
            case .success(let response):
                self.reviewList = ReviewList.parse(data: response.data, vc: vc)
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 영화 리뷰를 삭제합니다.
    /// - Parameters:
    ///   - id: 리뷰 ID
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func deleteReview(id: Int, vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.removeReview(id)) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 영화 리뷰를 저장합니다.
    /// - Parameter reviewPostData: 저장할 리뷰 데이터
    /// - Parameter vc: 메소드를 실행하는 뷰컨트롤러
    func saveReview(reviewPostData: ReviewPostData, vc: CommonViewController) {
        provider.request(.saveReview(reviewPostData)) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .reviewDidSaved, object: nil)
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 영화 리뷰를 수정합니다.
    /// - Parameter reviewPutData: 수정된 리뷰 데이터
    /// - Parameter vc: 메소드를 실행하는 뷰컨트롤러
    func editReview(reviewPutData: ReviewPutData, vc: CommonViewController) {
        provider.request(.editReview(reviewPutData)) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: .reviewDidUpdate, object: nil)
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 영화관 목록 관련 네트워크 호출 결과를 방출하는 옵저버블을 리턴합니다.
    /// - Returns: 영화관 목록 관련 네트워크 호출 결과를 방출하는 옵저버블
    func fetchMovieTheater() -> Single<Response> {
        return provider.rx
            .request(.movieTheaterList)
            .retry(20)
    }
}
