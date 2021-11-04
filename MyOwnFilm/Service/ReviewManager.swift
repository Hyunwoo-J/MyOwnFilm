//
//  ReviewManager.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/26.
//

import UIKit


extension Notification.Name {
    /// 새로운 리뷰를 저장할 때 보낼 노티피케이션
    static let reviewDidSaved = Notification.Name(rawValue: "reviewDidSaved")
    
    /// 리뷰를 업데이트할 때 보낼 노티피케이션
    static let reviewDidUpdate = Notification.Name(rawValue: "reviewDidUpdate")
}



/// 리뷰 매니저
class ReviewManager {
    
    /// 싱글톤
    static let shared = ReviewManager()
    
    /// 싱글톤
    private init() { }
    
    /// 리뷰 목록
    var reviewList = [ReviewListResponse.Review]()
    
    /// 세션
    let session = URLSession.shared
    
    /// ISO8601DateFormatter
    ///
    /// 데이터를 POST 할 때 사용하기 위해서 만들었습니다.
    let postDateFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        return f
    }()
    
    
    /// 서버로 요청을 보냅니다.
    /// - Parameters:
    ///   - url: 리퀘스트 url
    ///   - httpMethod: 요청 메소드
    ///   - httpBody: 전달할 데이터
    ///   - notificationName: 서버 응답을 받은 후 보낼 노티피케이션
    private func sendRequest(url: URL, httpMethod: String, httpBody: Data?, notificationName: Notification.Name) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: AccountKeys.apiToken.rawValue) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        session.dataTask(with: request) { data, response, error in
            defer {
                print(">>>END")
            }
            
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let apiResponse = try decoder.decode(CommonResponse.self, from: data)
                    
                    switch apiResponse.code {
                    case ResultCode.ok.rawValue:
                        NotificationCenter.default.post(name: notificationName, object: nil)
                        
                        print("추가 성공")
                    case ResultCode.fail.rawValue:
                        print("추가 실패")
                    default:
                        break
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    /// 영화 리뷰를 다운로드합니다.
    /// - Parameter completion: 완료 블록
    func fetchReview(completion: @escaping () -> ()) {
        guard let url = URL(string: "https://mofapi.azurewebsites.net/review") else { return }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: AccountKeys.apiToken.rawValue) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        session.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(ReviewListResponse.self, from: data)
                    self.reviewList = result.list
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    /// 영화 리뷰를 저장합니다.
    /// - Parameters:
    ///   - index: 이전 화면에서 전달받은 인덱스
    ///   - movieList: 영화 배열
    ///   - reviewData: 리뷰 데이터
    ///   - starPoint: 별점
    ///   - viewingDate: 영화 본 날짜
    ///   - movieTheater: 영화관
    ///   - person: 같이 본 친구
    ///   - memo: 메모
    func saveReviewData(index: Int?, movieList: [MovieData.Result], reviewData: ReviewListResponse.Review?, starPoint: Double, viewingDate: String, movieTheater: String, person: String, memo: String) {
        
        let updateDate = postDateFormatter.string(from: Date())
        
        if let index = index {
            let target = movieList[index]
            
            let reviewData = ReviewPostData(movieId: target.id, movieTitle: target.titleStr, backdropPath: target.backdropPath, posterPath: target.posterPath, releaseDate: target.releaseDate, starPoint: starPoint, viewingDate: viewingDate, movieTheater: movieTheater, person: person, memo: memo, updateDate: updateDate)
            
            guard let url = URL(string: "https://mofapi.azurewebsites.net/review") else { return }
            
            let encoder = JSONEncoder()
            let body = try? encoder.encode(reviewData)
            
            sendRequest(url: url, httpMethod: "POST", httpBody: body, notificationName: .reviewDidSaved)
        } else {
            guard let reviewData = reviewData else {
                return
            }
            
            let reviewPutData = ReviewPutData(reviewId: reviewData.reviewId ,movieId: reviewData.movieId, movieTitle: reviewData.movieTitle, backdropPath: reviewData.backdropPath, posterPath: reviewData.posterPath, releaseDate: reviewData.releaseDate, starPoint: starPoint, viewingDate: viewingDate, movieTheater: movieTheater, person: person, memo: memo, updateDate: updateDate)
            
            guard let url = URL(string: "https://mofapi.azurewebsites.net/review/\(reviewData.reviewId)") else { return }
            
            let encoder = JSONEncoder()
            let body = try? encoder.encode(reviewPutData)
            
            sendRequest(url: url, httpMethod: "PUT", httpBody: body, notificationName: .reviewDidUpdate)
        }
    }
    
    
    /// 작성한 영화 리뷰를 삭제합니다.
    /// - Parameter id: 리뷰 ID
    /// - Parameter completion: 완료 블록
    func deleteReview(id: Int, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://mofapi.azurewebsites.net/review/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: AccountKeys.apiToken.rawValue) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let apiResponse = try decoder.decode(CommonResponse.self, from: data)
                    
                    if apiResponse.code == ResultCode.ok.rawValue {
                        DispatchQueue.main.async {
                            completion()
                        } 
                    } else {
                        if let message = apiResponse.message {
                            print(message)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }).resume()
    }
}
