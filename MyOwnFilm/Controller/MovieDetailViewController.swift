//
//  MovieDetailViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/06.
//

import NSObject_Rx
import RxSwift
import UIKit


/// 영화 상세 정보 화면
class MovieDetailViewController: CommonViewController {
    
    /// 백그라운드 이미지뷰
    @IBOutlet weak var backgroundmovieImageView: UIImageView!
    
    /// 영화 줄거리 레이블
    @IBOutlet weak var storyLabel: UILabel!
    
    /// 영화 제목 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 개봉 일자 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    
    /// 이전 화면에서의 데이터를 가져오기 위한 속성
    /// 인덱스
    var index: Int?
    
    /// 영화 데이터
    var movieData: MovieData.Result?
    
    /// 영화 목록
    var movieList = [MovieData.Result]()
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 이전 화면으로 돌아갑니다.
    /// - Parameter sender: X 버튼
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    ///
    /// window에 dimming View를 추가합니다.
    /// - Parameters:
    ///   - segue: ViewController 정보를 가지고 있는 seuge
    ///   - sender: 리뷰 작성 버튼
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        if let vc = segue.destination as? ReviewViewController {
            window.addSubview(self.dimView)
            vc.index = index
            vc.movieList = movieList
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 상세 화면에 표시할 이미지를 다운로드합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [storyLabel, titleLabel, dateLabel].forEach { $0?.textColor = .white }
        
        if let index = index {
            storyLabel.text = movieList[index].overviewStr
            titleLabel.text = movieList[index].titleStr
            dateLabel.text = movieList[index].releaseDate.toManagerDate()?.toUserDateStringForMovieData()
        }
        
        if let movieData = movieData {
            MovieImageManager.shared.loadImage(from: movieData.backdropPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                self.backgroundmovieImageView.image = img
            }
        } else {
            self.backgroundmovieImageView.image = UIImage(named: DefaultImageName.defaultImage.rawValue)
        }
        
        NotificationCenter.default.rx.notification(.reviewWillCancelled, object: nil)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                UIView.animate(withDuration: 0.3) {
                    self.dimView.removeFromSuperview()
                }
            }
            .disposed(by: rx.disposeBag)
    }
}
