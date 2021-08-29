//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/07/27.
//

import UIKit

class MemoViewController: UIViewController {
    @IBOutlet weak var memoBackdropImageView: UIImageView!
    
    /// 이전 화면에서의 데이터를 가져오기 위한 변수
    var index: Int?
    var movieList = [MovieData.Results]()
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// X 버튼을 누르면 이전 화면으로 돌아갑니다.
    /// - Parameter sender: 버튼
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
