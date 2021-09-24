//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/07/27.
//

import UIKit
import Cosmos

extension Notification.Name {
    static let memoWillCancelled = Notification.Name(rawValue: "memoWillCancelled")
}




class ReviewViewController: CommonViewController {
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoBackdropImageView: UIImageView!
    @IBOutlet weak var starPointView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var friendTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    
    
    /// 이전 화면에서의 데이터를 가져오기 위한 변수
    var index: Int?
    var movieList = [MovieData.Results]()
    var movieData: MovieReview?
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        placeTextField.delegate = self
        friendTextField.delegate = self
        
        starPointView.settings.fillMode = .half
        starPointView.rating = 0
        
        setMemoView()
        setTextView()
        loadImage()
        
        if let movieData = movieData {
            MovieImageSource.shared.loadImage(from: movieData.backdropPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                if let img = img {
                    self.memoBackdropImageView.image = img
                } else {
                    self.memoBackdropImageView.image = UIImage(named: "Default Image")
                }
            }
            
            starPointView.rating = movieData.starPoint
            dateLabel.text = movieData.date.toUserDateString()
            placeTextField.text = movieData.place
            friendTextField.text = movieData.friend
            memoTextView.text = movieData.memo
        }
    }
    
    
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
    
    
    /// 빈 화면을 터치하면 키보드가 내려갑니다.
    /// - Parameters:
    ///   - touches: <#touches description#>
    ///   - event: <#event description#>
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func setMemoView() {
        memoView.layer.cornerRadius = 8
        memoView.layer.shadowColor = UIColor.black.cgColor
        memoView.layer.shadowRadius = 1
        memoView.layer.shadowOpacity = 0.3
        memoView.layer.masksToBounds = true
    }
    
    
    func setTextView() {
        memoTextView.layer.cornerRadius = 8
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    /// X 버튼을 누르면 이전 화면으로 돌아갑니다.
    /// - Parameter sender: 버튼
    @IBAction func close(_ sender: Any) {
        NotificationCenter.default.post(name: .memoWillCancelled, object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    
    @IBAction func saveReview(_ sender: Any) {
        guard let index = index else { return }
        
        let target = movieList[index]
        let review = MovieReview(reviewId: UUID(),
                                 movieTitle: target.titleStr,
                                 posterPath: target.posterPath,
                                 backdropPath: target.backdropPath,
                                 releaseDate: target.releaseDate.toManagerDate() ?? Date(),
                                 starPoint: starPointView.rating,
                                 date: dateLabel.text?.toManagerMemoDate() ?? Date(),
                                 place: placeTextField.text ?? "",
                                 friend: friendTextField.text ?? "",
                                 memo: memoTextView.text)
        
        MovieReview.movieReviewList.append(review)
        
        #if DEBUG
        dump(MovieReview.movieReviewList)
        #endif
        
        close(self)
    }
    
    
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
        
        /// alert 제약 추가
        dateAlert.view.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        /// DatePicker 제약 추가
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: dateAlert.view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: dateAlert.view.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: dateAlert.view.topAnchor, constant: 0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: dateAlert.view.bottomAnchor, constant: -100).isActive = true
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let date = datePicker.date.releaseDate.toManagerDate() else { return }
            
            self.dateLabel.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: nil)
            
            self.dateLabel.text = date.toUserDateString()
        }
        dateAlert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        
        present(dateAlert, animated: true, completion: nil)
    }
}




extension ReviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeTextField.resignFirstResponder()
        friendTextField.resignFirstResponder()
        
        return true
    }
}
