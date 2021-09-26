//
//  MovieDetailViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/06.
//

import UIKit


/// 영화 상세 정보를 표시하는 화면과 관련된 뷰컨트롤러 클래스
class MovieDetailViewController: CommonViewController {
    /// 백그라운드에 표시할 이미지를 넣을 이미지뷰
    @IBOutlet weak var backgroundmovieImageView: UIImageView!
    
    /// 영화 줄거리를 넣을 레이블
    @IBOutlet weak var storyLabel: UILabel!
    
    /// 영화 제목을 넣을 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 개봉 일자를 넣을 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 노티피케이션 옵저를 제거하기 위해 생성한 토큰
    var token: NSObjectProtocol?
    
    /// 이전 화면에서의 데이터를 가져오기 위한 변수
    /// 인덱스
    var index: Int?
    
    /// 영화 데이터
    var movieData: MovieData.Result?
    
    /// 영화 리스트
    var movieList = [MovieData.Result]()
    
    
    /// X 버튼을 누르면 이전 화면으로 돌아갑니다.
    /// - Parameter sender: 버튼
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// Segue가 실행될 것을 뷰컨트롤러에게 알립니다.
    /// - Parameters:
    ///   - segue: seuge에 관련되 뷰 컨트롤러에 대한 정보를 포함한 개체
    ///   - sender: segue를 시작한 개체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // window에 dimming View를 추가
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        if let vc = segue.destination as? ReviewViewController {
            window.addSubview(self.dimView)
            vc.index = index
            vc.movieList = movieList
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백그라운드, 텍스트 색상 변경
        view.backgroundColor = .black
        [storyLabel, titleLabel, dateLabel].forEach { $0?.textColor = .white }
        
        // 인덱스가 있다면 레이블에 관련 텍스트를 넣어줍니다.
        if let index = index {
            storyLabel.text = movieList[index].overviewStr
            titleLabel.text = movieList[index].titleStr
            dateLabel.text = movieList[index].releaseDate.toManagerDate()?.toUserDateStringForMovieData()
        }
        
        // 상세 화면에 표시할 이미지를 다운로드합니다.
        if let movieData = movieData {
            MovieImageSource.shared.loadImage(from: movieData.backdropPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                self.backgroundmovieImageView.image = img
            }
        } else {
            self.backgroundmovieImageView.image = UIImage(named: "Default Image")
        }
        
        token = NotificationCenter.default.addObserver(forName: .memoWillCancelled, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            
            // DimView 제거
            UIView.animate(withDuration: 0.3) {
                self.removeViewFromWindow()
            }
        }
    }
    
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
