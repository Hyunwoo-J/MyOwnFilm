//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/07/27.
//

import Cosmos
import Loaf
import UIKit


extension Notification.Name {
    /// 리뷰 작성이 취소되면 보낼 노티피케이션
    static let reviewWillCancelled = Notification.Name(rawValue: "reviewWillCancelled")
}



/// 리뷰 작성 화면
class ReviewViewController: CommonViewController {
    
    /// 리뷰 작성 화면 컨테이너 뷰
    @IBOutlet weak var memoView: UIView!
    
    /// 백그라운드 이미지뷰
    @IBOutlet weak var memoBackdropImageView: UIImageView!
    
    /// 별점 뷰
    @IBOutlet weak var starPointView: CosmosView!
    
    /// 작성 날짜 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 데이트 피커를 띄우는 버튼
    @IBOutlet weak var dateButton: UIButton!
    
    /// 영화 관람 장소 레이블
    @IBOutlet weak var placeLabel: UILabel!
    
    /// 영화 장소 버튼
    @IBOutlet weak var placeButton: UIButton!
    
    /// 같이 본 친구 입력 필드
    @IBOutlet weak var friendTextField: UITextField!
    
    /// 메모 텍스트뷰
    @IBOutlet weak var memoTextView: UITextView!
    
    /// 메모 뷰 Top 제약
    @IBOutlet weak var memoViewTopConstraint: NSLayoutConstraint!
    
    /// 메모 뷰 Bottom 제약
    @IBOutlet weak var memoViewBottomConstraint: NSLayoutConstraint!
    
    
    /// 이전 화면에서의 데이터를 가져오기 위한 속성
    /// 인덱스
    var index: Int?
    
    /// 영화 데이터
    var movieData: ReviewListResponse.Review?
    
    /// 영화 리스트
    var movieList = [MovieData.Result]()
    
    
    /// 세션
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        
        return session
    }()
    
    /// ISO8601DateFormatter
    ///
    /// 데이터를 POST 할 때 사용하기 위해서 만들었습니다.
    let postDateFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        return f
    }()
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 취소 버튼을 누르면 이전 화면으로 돌아갑니다.
    /// - Parameter sender: 취소 버튼
    @IBAction func close(_ sender: Any) {
        
        NotificationCenter.default.post(name: .reviewWillCancelled, object: nil, userInfo: nil)
        
        dismiss(animated: true)
        dismiss(animated: true)
    }
    
    
    /// 영화 리뷰를 저장합니다.
    ///
    /// 데이터베이스에 POST 합니다.
    /// - Parameter sender: 확인 버튼
    @IBAction func saveReview(_ sender: Any) {
        if starPointView.rating == 0 {
            alertLoafMessage(message: "평점을 입력해주세요.", duration: .short)
            return
        }
        
        guard let date = dateLabel.text?.toManagerMemoDate() else {
            alertLoafMessage(message: "영화 본 날짜를 입력해주세요.", duration: .short)
            return
        }
        
        guard let place = placeLabel.text, !place.isEmpty else {
            alertLoafMessage(message: "영화 본 장소를 입력해주세요.", duration: .short)
            return
        }
        
        guard let friend = friendTextField.text, !friend.isEmpty else {
            alertLoafMessage(message: "같이 본 친구를 입력해주세요.", duration: .short)
            return
        }
        
        let rating = starPointView.rating
        let text = memoTextView.text
        
        let viewingDate = postDateFormatter.string(from: date)
        
        DispatchQueue.global().async {
            self.insertReviewData(starPoint: rating, viewingDate: viewingDate, movieTheater: place, person: friend, memo: text ?? "")
        }
        
        close(self)
    }
    
    
    /// 관람일 관련 버튼을 클릭하면 데이트 피커를 띄웁니다.
    /// - Parameter sender: 데이트 피커를 띄우는 버튼
    @IBAction func dateButtonTapped(_ sender: Any) {
        let dateAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            
        }
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_kr")
        
        dateAlert.view.addSubview(datePicker)
        
        // alert 제약 추가
        dateAlert.view.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // DatePicker 제약 추가
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: dateAlert.view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: dateAlert.view.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: dateAlert.view.topAnchor, constant: 0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: dateAlert.view.bottomAnchor, constant: -100).isActive = true
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let date = datePicker.date.releaseDate.toManagerDate() else { return }
            
            self.dateLabel.textColor = .white
            
            self.dateLabel.text = date.toUserDateString()
        }
        dateAlert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        
        present(dateAlert, animated: true, completion: nil)
    }
    
    
    /// 데이터베이스에 영화 리뷰를 저장합니다.
    /// - Parameters:
    ///   - starPoint: 별점
    ///   - viewingDate: 영화 본 날짜
    ///   - movieTheater: 영화관
    ///   - person: 같이 본 친구
    ///   - memo: 메모
    func insertReviewData(starPoint: Double, viewingDate: String, movieTheater: String, person: String, memo: String) {
        guard let index = index else {
            return
        }
        
        let target = movieList[index]
        
        let updateDate = postDateFormatter.string(from: Date())
        
        let reviewData = ReviewPostData(movieTitle: target.titleStr, posterPath: target.posterPath, backdropPath: target.backdropPath, releaseDate: target.releaseDate, starPoint: starPoint, viewingDate: viewingDate, movieTheater: movieTheater, person: person, memo: memo, updateDate: updateDate)
        
        guard let url = URL(string: "https://localhost:53007/review") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(reviewData)
        } catch {
            print(error)
        }
        
        session.dataTask(with: request) { data, response, error in
            defer {
                print(">>>END", reviewData.movieTitle)
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
                    
                    switch apiResponse.resultCode {
                    case ResultCode.ok.rawValue:
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
    
    
    /// 이미지를 다운로드하고 표시합니다.
    func loadImage() {
        if let index = index {
            MovieImageSource.shared.loadImage(from: movieList[index].backdropPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                if let img = img {
                    self.memoBackdropImageView.image = img
                } else {
                    self.memoBackdropImageView.image = UIImage(named: "Default Image")
                }
            }
        }
    }
    
    
    /// 메모 화면 UI를 설정합니다.
    func setMemoView() {
        memoView.layer.cornerRadius = 8
        memoView.layer.shadowColor = UIColor.black.cgColor
        memoView.layer.shadowRadius = 1
        memoView.layer.shadowOpacity = 0.3
        memoView.layer.masksToBounds = true
    }
    
    
    /// 텍스트뷰 UI를 설정합니다.
    func setTextView() {
        memoTextView.layer.cornerRadius = 8
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    /// 빈 화면을 터치하면 키보드가 내려갑니다.
    /// - Parameters:
    ///   - touches: UITouch 인스턴스 Set
    ///   - event: 터치가 속한 이벤트
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoView()
        setTextView()
        loadImage()
        
        friendTextField.delegate = self
        
        starPointView.settings.fillMode = .half
        starPointView.rating = 0
        
        [dateButton, placeButton, friendTextField].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
        }
        
        if let movieData = movieData {
            MovieImageSource.shared.loadImage(from: movieData.backdropPath ?? "", posterImageSize: PosterImageSize.w780.rawValue) { img in
                if let img = img {
                    self.memoBackdropImageView.image = img
                } else {
                    self.memoBackdropImageView.image = UIImage(named: "Default Image")
                }
            }
            
            starPointView.rating = movieData.starPoint
            dateLabel.text = movieData.viewingDate
            placeLabel.text = movieData.movieTheater
            friendTextField.text = movieData.person
            memoTextView.text = movieData.memo
            
            dateLabel.textColor = .white
            placeLabel.textColor = .white
        }
        
        token = NotificationCenter.default.addObserver(forName: .memoDidSaved, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let memoText = noti.userInfo?["memo"] as? String {
                self.memoTextView.text = memoText
            }
        }
        
        if let token = token {
            tokens.append(token)
        }
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            self.memoViewTopConstraint.constant = 70
            self.memoViewBottomConstraint.constant = 90
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        if let token = token {
            tokens.append(token)
        }
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            self.memoViewTopConstraint.constant = 80
            self.memoViewBottomConstraint.constant = 80
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        if let token = token {
            tokens.append(token)
        }
        
        token = NotificationCenter.default.addObserver(forName: .movieTheaterTableViewCellDidTapped, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let theater = noti.userInfo?["theater"] as? String {
                self.placeLabel.text = theater
                self.placeLabel.textColor = .white
            }
        }
        
        if let token = token {
            tokens.append(token)
        }
    }
}



/// 사용자 동작을 처리하기 위한 extension
extension ReviewViewController: UITextFieldDelegate {
    
    /// Return 버튼 처리 여부를 리턴합니다.
    /// - Parameter textField: 같이 본 친구 입력 필드
    /// - Returns: 처리 여부
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        friendTextField.resignFirstResponder()
        
        return true
    }
}



extension ReviewViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let trust = challenge.protectionSpace.serverTrust!
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}
