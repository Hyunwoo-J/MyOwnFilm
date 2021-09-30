//
//  StorageViewController.swift
//  StorageViewController
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit


/// 보관함 화면 관련 뷰컨트롤러 클래스
class StorageViewController: CommonViewController {
    /// 기록한 영화를 표시할 컬렉션뷰
    @IBOutlet weak var storageCollectionView: UICollectionView!
    
    /// 모든 영화를 표시하는 버튼
    @IBOutlet weak var allMovieButton: UIButton!
    
    /// 전체 영화 레이블 밑에 표시할 뷰
    @IBOutlet weak var allMovieBottomView: UIView!
    
    /// 최근 저장할 영화를 표시하는 버튼
    @IBOutlet weak var recentlyMovieButton: UIButton!
    
    /// 최근 저장한 영화 레이블 밑에 표시할 뷰
    @IBOutlet weak var recentlyMovieBottomView: UIView!
    
    /// 최근 저장한 영화 버튼이 선택됐는지 알기 위해 추가한 변수
    var isRecentlyMovieButtonSelected = false
    
    
    /// 선택된 버튼에 따라 영화 데이터를 표시합니다.
    /// - Parameter sender: 버튼
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
            MovieReview.recentlyMovieReviewList = MovieReview.movieReviewList.filter { reviewData in
                let dateBeforeThreeMonth = Date() - 3.month
                
                return reviewData.date > dateBeforeThreeMonth
            }
            
            isRecentlyMovieButtonSelected = true
        } else {
            isRecentlyMovieButtonSelected = false
        }
    }
    
    
    /// 정렬 버튼을 누르면 정렬과 관련된 액션시트를 표시합니다.
    /// - Parameter sender: 정렬 버튼
    @IBAction func alignmentButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 개봉연도 최근순
        let openingYearAction = UIAlertAction(title: "개봉연도", style: .default) { act in
            if self.isRecentlyMovieButtonSelected == false {
                MovieReview.movieReviewList.sort { $0.releaseDate > $1.releaseDate }
            } else {
                MovieReview.recentlyMovieReviewList.sort { $0.releaseDate > $1.releaseDate }
            }
            
            self.storageCollectionView.reloadData()
        }
        alert.addAction(openingYearAction)
        
        // 최근 본 영화순
        let dateAction = UIAlertAction(title: "내가 본 날짜", style: .default) { act in
            if self.isRecentlyMovieButtonSelected == false {
                MovieReview.movieReviewList.sort { $0.date > $1.date }
            } else {
                MovieReview.recentlyMovieReviewList.sort { $0.date > $1.date }
            }
            
            self.storageCollectionView.reloadData()
        }
        alert.addAction(dateAction)
        
        // 이름 오름차순 ㄱㄴㄷ
        let movieNameAction = UIAlertAction(title: "영화 이름", style: .default) { act in
            if self.isRecentlyMovieButtonSelected == false {
                MovieReview.movieReviewList.sort { $0.movieTitle < $1.movieTitle }
            } else {
                MovieReview.recentlyMovieReviewList.sort { $0.movieTitle < $1.movieTitle }
            }
            
            self.storageCollectionView.reloadData()
        }
        alert.addAction(movieNameAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .memoWillCancelled, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            
            // DimView 제거
            UIView.animate(withDuration: 0.3) {
                self.removeViewFromWindow()
            }
        }
    }
    
    
    /// 뷰가 나타나기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 사용 여부
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
        storageCollectionView.reloadData()
    }
    
    
    /// 뷰의 사이즈가 변경되면 호출됩니다.
    /// - Parameters:
    ///   - size: 뷰의 새로운 사이즈
    ///   - coordinator: 사이즈 변경을 관리하는 코디네이터 객체
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if storageCollectionView != nil {
            storageCollectionView.reloadData()
        }
    }
}



extension StorageViewController: UICollectionViewDataSource {
    /// 데이터소스 객체에게 지정된 섹션에 아이템 수를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - section: 컬렉션뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션 아이템의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isRecentlyMovieButtonSelected {
            return MovieReview.recentlyMovieReviewList.count
        }
        
        return MovieReview.movieReviewList.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorageCollectionViewCell", for: indexPath) as! StorageCollectionViewCell
        
        if isRecentlyMovieButtonSelected {
            let target = MovieReview.recentlyMovieReviewList[indexPath.row]
            cell.configure(with: target)
            
            return cell
        }
        
        let target = MovieReview.movieReviewList[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



extension StorageViewController: UICollectionViewDelegate {
    /// 델리게이트에게 지정된 인덱스패스에 있는 항목이 선택되었음을 알립니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MemoViewController") as? ReviewViewController {
            guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
            window.addSubview(self.dimView)
            
            if isRecentlyMovieButtonSelected == false {
                vc.movieData = MovieReview.movieReviewList[indexPath.row]
            } else {
                vc.movieData = MovieReview.recentlyMovieReviewList[indexPath.row]
            }
            
            
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}



extension StorageViewController: UICollectionViewDelegateFlowLayout {
    /// 델리게이트에게 지정된 아이템의 셀 크기를 요청합니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - collectionViewLayout: 정보를 요청하는 레이아웃 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 지정된 아이템의 너비와 높이(사이즈)
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
