//
//  MovieDetailViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/06.
//

import UIKit

class MovieDetailViewController: CommonViewController {
    @IBOutlet weak var backgroundmovieImage: UIImageView!
    
    /// 영화 줄거리를 넣을 레이블
    @IBOutlet weak var storyLabel: UILabel!
    /// 영화 제목을 넣을 레이블
    @IBOutlet weak var titleLabel: UILabel!
    /// 개봉 일자를 넣을 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 이전 화면에서의 데이터를 가져오기 위한 변수
    var index: Int?
    var movieData: MovieData.Results?
    var movieList = [MovieData.Results]()
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// Segue가 실행될 것을 뷰컨트롤러에게 알립니다.
    /// - Parameters:
    ///   - segue: seuge에 관련되 뷰 컨트롤러에 대한 정보를 포함한 개체
    ///   - sender: segue를 시작한 개체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// window에 dimming View를 추가
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        if let vc = segue.destination as? ReviewViewController {
            window.addSubview(self.dimView)
            vc.index = index
            vc.movieList = movieList
        }
    }
    
    
    /// X 버튼을 누르면 이전 화면으로 돌아갑니다.
    /// - Parameter sender: 버튼
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 백그라운드, 텍스트 색상 변경
        view.backgroundColor = .black
        [storyLabel, titleLabel, dateLabel].forEach { $0?.textColor = .white }
        
        /// 인덱스가 있다면 레이블에 관련 텍스트를 넣어줍니다.
        if let index = index {
            storyLabel.text = movieList[index].overviewStr
            titleLabel.text = movieList[index].titleStr
            dateLabel.text = movieList[index].releaseDate.toManagerDate()?.toUserDateStringForMovieData()
        }
        
        // 다운로드
        if let movieData = movieData {
            MovieImageSource.shared.loadImage(from: movieData.backdropPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                self.backgroundmovieImage.image = img
            }
        } else {
            self.backgroundmovieImage.image = UIImage(named: "Default Image")
        }
        
        NotificationCenter.default.addObserver(forName: .memoWillCancelled, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            
            /// DimView 제거
            UIView.animate(withDuration: 0.3) {
                self.removeViewFromWindow()
            }
        }
    }
}
