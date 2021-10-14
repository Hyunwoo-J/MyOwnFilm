//
//  StorageViewController.swift
//  StorageViewController
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit


/// 보관함 화면
class StorageViewController: CommonViewController {
    
    /// 리뷰를 작성한 영화 목록 컬렉션뷰
    @IBOutlet weak var storageCollectionView: UICollectionView!
    
    /// 모든 영화를 표시하는 버튼
    @IBOutlet weak var allMovieButton: UIButton!
    
    /// 전체 영화 레이블 밑에 표시할 뷰
    @IBOutlet weak var allMovieBottomView: UIView!
    
    /// 최근 저장한 영화를 표시하는 버튼
    @IBOutlet weak var recentlyMovieButton: UIButton!
    
    /// 최근 저장한 영화 레이블 밑에 표시할 뷰
    @IBOutlet weak var recentlyMovieBottomView: UIView!
    
    /// 정렬 레이블
    ///
    /// 어떤 기준을 가지고 정렬하고 있는지 나타냅니다.
    @IBOutlet weak var alignmentLabel: UILabel!
    
    /// 정렬 상태 레이블
    ///
    /// 오름차순인지 내림차순인지 나타냅니다.
    @IBOutlet weak var alignmentStateLabel: UILabel!
    
    /// 정렬 관련 화살표 모양 이미지뷰
    @IBOutlet weak var alignmentArrowImageView: UIImageView!
    
    /// 최근 저장한 영화 버튼이 선택됐는지 알기 위해 추가한 속성
    var isRecentlyMovieButtonSelected = false
    
    /// 개봉연도순 정렬이 오름차순인지 판단하기 위해 추가한 속성
    var isOpeningYearAscending = false
    
    /// 내가 본 날짜순 정렬이 오름차순인지 판단하기 위해 추가한 속성
    var isDateAscending = false
    
    /// 영화이름순 정렬이 오름차순인지 판단하기 위해 추가한 속성
    var isMovieNameAscending = true
    
    
    /// 전체 리뷰 목록
    var reviewList = [ReviewListResponse.Review]()
    
    /// 최근 저장한 리뷰 목록
    var recentlyReviewList = [ReviewListResponse.Review]()
    
    
    /// 세션
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        var session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        
        return session
    }()
    
    
    /// 선택된 항목에 따라 영화 데이터를 표시합니다.
    ///
    /// 최근 저장한 영화 항목을 선택하면 최근 3개월간 작성한 리뷰 목록을 표시합니다.
    /// - Parameter sender: 모든 영화를 표시하는 버튼, 최근 저장한 영화를 표시하는 버튼
    @IBAction func toggleMovieList(_ sender: UIButton) {
        defer {
            DispatchQueue.main.async {
                self.storageCollectionView.reloadData()
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.recentlyMovieBottomView.backgroundColor = sender.tag == 100 ? .darkGray : .black
            self.allMovieBottomView.backgroundColor = sender.tag == 101 ? .darkGray : .black
        }
        
        if sender.tag == 100 {
            recentlyReviewList = reviewList.filter { reviewData in
                let dateBeforeThreeMonth = Date() - 3.month
                
                guard let date = reviewData.viewingDate.toManagerDBDate() else {
                    return false
                }
                return date > dateBeforeThreeMonth
            }
            
            isRecentlyMovieButtonSelected = true
        } else {
            isRecentlyMovieButtonSelected = false
        }
    }
    
    
    /// 정렬과 관련된 액션시트를 표시합니다.
    /// - Parameter sender: 정렬 버튼
    @IBAction func alignmentButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openingYearAction = UIAlertAction(title: "개봉연도", style: .default) { act in
            self.isOpeningYearAscending = false
            self.sortByYearOfRelease()
        }
        alert.addAction(openingYearAction)
        
        let dateAction = UIAlertAction(title: "내가 본 날짜", style: .default) { act in
            self.isDateAscending = false
            self.sortByDateISaw()
        }
        alert.addAction(dateAction)
        
        let movieNameAction = UIAlertAction(title: "영화 이름", style: .default) { act in
            self.isMovieNameAscending = true
            self.sortByMovieName()
        }
        alert.addAction(movieNameAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 정렬 상태가 변경됩니다.
    ///
    /// 오름차순이면 내림차순으로, 내림차순이면 오름차순으로 정렬 상태가 변경됩니다.
    /// - Parameter sender: 정렬 상태 관련 버튼
    @IBAction func toggleAlignmentOption(_ sender: Any) {
        if let alignmentText = alignmentLabel.text {
            switch alignmentText {
            case "개봉연도":
                sortByYearOfRelease()
            case "내가 본 날짜":
                sortByDateISaw()
            case "영화 이름":
                sortByMovieName()
            default:
                return
            }
        }
    }
    
    
    /// 개봉연도를 기준으로 정렬합니다.
    func sortByYearOfRelease() {
        [self.alignmentStateLabel, self.alignmentArrowImageView].forEach { $0?.isHidden = false }
        
        self.alignmentLabel.text = "개봉연도"
        
        if self.isOpeningYearAscending {
            recentlyReviewList.sort { $0.releaseDate < $1.releaseDate }
            reviewList.sort { $0.releaseDate < $1.releaseDate }
            
            self.alignmentStateLabel.text = "오래된 날짜순"
            self.alignmentArrowImageView.image = UIImage(named: "up-arrow")
        } else {
            recentlyReviewList.sort { $0.releaseDate > $1.releaseDate }
            reviewList.sort { $0.releaseDate > $1.releaseDate }
            
            self.alignmentStateLabel.text = "최근 날짜순"
            self.alignmentArrowImageView.image = UIImage(named: "down-arrow")
        }
        
        self.isOpeningYearAscending = !self.isOpeningYearAscending
        
        self.storageCollectionView.reloadData()
    }
    
    
    /// 내가 본 날짜를 기준으로 정렬합니다.
    func sortByDateISaw() {
        [self.alignmentStateLabel, self.alignmentArrowImageView].forEach { $0?.isHidden = false }
        
        self.alignmentLabel.text = "내가 본 날짜"
        
        if self.isDateAscending {
            recentlyReviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() < $1.viewingDate.toManagerDBDate() ?? Date() }
            reviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() < $1.viewingDate.toManagerDBDate() ?? Date() }
            
            self.alignmentStateLabel.text = "오래된 날짜순"
            self.alignmentArrowImageView.image = UIImage(named: "up-arrow")
        } else {
            recentlyReviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() > $1.viewingDate.toManagerDBDate() ?? Date() }
            reviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() > $1.viewingDate.toManagerDBDate() ?? Date() }
            
            self.alignmentStateLabel.text = "최근 날짜순"
            self.alignmentArrowImageView.image = UIImage(named: "down-arrow")
        }
        
        self.isDateAscending = !self.isDateAscending
        
        self.storageCollectionView.reloadData()
    }
    
    
    /// 영화 이름을 기준으로 정렬합니다.
    func sortByMovieName() {
        [self.alignmentStateLabel, self.alignmentArrowImageView].forEach { $0?.isHidden = false }
        
        self.alignmentLabel.text = "영화 이름"
        
        if self.isMovieNameAscending {
            recentlyReviewList.sort { $0.movieTitle < $1.movieTitle }
            reviewList.sort { $0.movieTitle < $1.movieTitle }
            
            self.alignmentStateLabel.text = "가나다"
            self.alignmentArrowImageView.image = UIImage(named: "up-arrow")
        } else {
            recentlyReviewList.sort { $0.movieTitle > $1.movieTitle }
            reviewList.sort { $0.movieTitle > $1.movieTitle }
            
            self.alignmentStateLabel.text = "하파타"
            self.alignmentArrowImageView.image = UIImage(named: "down-arrow")
        }
        
        self.isMovieNameAscending = !self.isMovieNameAscending
        
        self.storageCollectionView.reloadData()
    }
    
    
    /// 영화 리뷰를 다운로드합니다.
    private func fetchReview() {
        guard let url = URL(string: "https://localhost:53007/review") else { return }
        
        session.dataTask(with: url) { data, response, error in
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
                    
                    DispatchQueue.main.async {
                        self.storageCollectionView.reloadData()
                        self.sortReviewData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    /// 리뷰 데이터를 정렬합니다.
    ///
    /// 정렬 기준과 기준 순서에 따라 데이터를 정렬합니다.
    func sortReviewData() {
        if alignmentLabel.text == "개봉연도" && alignmentStateLabel.text == "오래된 날짜순" {
            reviewList.sort { $0.releaseDate.toManagerDBDate() ?? Date() < $1.releaseDate.toManagerDBDate() ?? Date() }
            recentlyReviewList.sort { $0.releaseDate.toManagerDBDate() ?? Date() < $1.releaseDate.toManagerDBDate() ?? Date() }
        } else if alignmentLabel.text == "개봉연도" && alignmentStateLabel.text == "최근 날짜순" {
            reviewList.sort { $0.releaseDate.toManagerDBDate() ?? Date() > $1.releaseDate.toManagerDBDate() ?? Date() }
            recentlyReviewList.sort { $0.releaseDate.toManagerDBDate() ?? Date() > $1.releaseDate.toManagerDBDate() ?? Date() }
        }
        
        
        if alignmentLabel.text == "내가 본 날짜" && alignmentStateLabel.text == "오래된 날짜순" {
            reviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() < $1.viewingDate.toManagerDBDate() ?? Date() }
            recentlyReviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() < $1.viewingDate.toManagerDBDate() ?? Date() }
        } else if alignmentLabel.text == "내가 본 날짜" && alignmentStateLabel.text == "최근 날짜순" {
            reviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() > $1.viewingDate.toManagerDBDate() ?? Date() }
            recentlyReviewList.sort { $0.viewingDate.toManagerDBDate() ?? Date() > $1.viewingDate.toManagerDBDate() ?? Date() }
        }
        
        if alignmentLabel.text == "영화 이름" && alignmentStateLabel.text == "가나다" {
            reviewList.sort { $0.movieTitle < $1.movieTitle }
            recentlyReviewList.sort { $0.movieTitle < $1.movieTitle }
        } else if alignmentLabel.text == "영화 이름" && alignmentStateLabel.text == "하파타" {
            reviewList.sort { $0.movieTitle > $1.movieTitle }
            recentlyReviewList.sort { $0.movieTitle > $1.movieTitle }
        }
        
        storageCollectionView.reloadData()
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .reviewWillCancelled, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.3) {
                self.removeDimViewFromWindow()
            }
        }
        
        [alignmentStateLabel, alignmentArrowImageView].forEach { $0?.isHidden = true }
    }
    
    
    /// 보관함 화면이 표시되기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 사용 여부
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchReview()
    }
    
    
    /// 뷰의 사이즈가 변경되면 호출됩니다.
    /// - Parameters:
    ///   - size: 뷰의 새로운 사이즈
    ///   - coordinator: 사이즈를 관리하는 객체
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if storageCollectionView != nil {
            storageCollectionView.reloadData()
        }
    }
}



/// 리뷰를 작성한 영화 목록 컬렉션뷰 데이터 관리
extension StorageViewController: UICollectionViewDataSource {
    
    /// 리뷰를 작성한 영화 목록수를 리턴합니다.
    ///
    /// 최근 저장한 영화 항목이 선택됐는지 여부에 따라 리턴하는 목록수가 다릅니다.
    /// - Parameters:
    ///   - collectionView: 리뷰를 작성한 영화 목록 컬렉션뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 리뷰를 작성한 영화 목록수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isRecentlyMovieButtonSelected {
            return recentlyReviewList.count
        }

        return reviewList.count
    }
    
    
    /// 저장한 리뷰 목록 데이터로 셀을 구성합니다.
    ///
    /// 최근 저장한 영화 항목이 선택됐는지 여부에 따라 구성하는 셀이 다릅니다.
    /// - Parameters:
    ///   - collectionView: 리뷰를 작성한 영화 목록 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorageCollectionViewCell", for: indexPath) as! StorageCollectionViewCell
        
        if isRecentlyMovieButtonSelected {
            let target = recentlyReviewList[indexPath.row]
            cell.configure(with: target)

            return cell
        }

        let target = reviewList[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



/// 리뷰를 작성한 영화 목록 컬렉션뷰와 관련된 사용자 동작을 처리
extension StorageViewController: UICollectionViewDelegate {
    
    /// 셀을 선택하면 호출됩니다.
    ///
    /// 리뷰 작성 화면이 표시되고 선택된 영화 리뷰 데이터를 ReviewViewController에 보냅니다.
    /// - Parameters:
    ///   - collectionView: 리뷰를 작성한 영화 목록 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController {
            guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
            window.addSubview(self.dimView)
            
            if isRecentlyMovieButtonSelected {
                vc.movieData = reviewList[indexPath.row]
            } else {
                vc.movieData = reviewList[indexPath.row]
            }
            
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}



/// 셀 사이즈를 지정하기 위해 추가
extension StorageViewController: UICollectionViewDelegateFlowLayout {
    
    /// 셀 사이즈를 리턴합니다.
    ///
    /// 세로 모드: 셀의 너비는 2등분, 높이는 너비의 150%로 지정합니다.
    /// 가로 모드: 셀의 너비는 4등분, 높이는 너비의 150%로 지정합니다.
    /// iPad: 셀의 너비는 5등분, 높이는 너비의 150%로 지정합니다.
    /// - Parameters:
    ///   - collectionView: 리뷰를 작성한 영화 목록 컬렉션뷰
    ///   - collectionViewLayout: 레이아웃 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 아이템 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return . zero }
        
        // iPad
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            let width = (collectionView.frame.width - ((flowLayout.minimumInteritemSpacing * 4) + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 5
            let height = width * 1.5
            
            return CGSize(width: Int(width), height: Int(height))
        }
        
        var width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
        var height = width * 1.5
        
        // 가로 모드
        if view.frame.width > view.frame.height {
            width = (collectionView.frame.width - ((flowLayout.minimumInteritemSpacing * 3) + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 4
            height = width * 1.5
        }
        
        return CGSize(width: Int(width), height: Int(height))
    }
}



/// 로컬 인증서 문제 해결
extension StorageViewController: URLSessionDelegate {
    
    /// 로컬 인증서 문제를 해결합니다.
    /// - Parameters:
    ///   - session: 세션
    ///   - challenge: 인증 요청 객체
    ///   - completionHandler: 완료 블록
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let trust = challenge.protectionSpace.serverTrust!
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}
