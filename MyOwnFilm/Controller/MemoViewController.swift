//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/07/27.
//

import UIKit

class MemoViewController: UIViewController {
    
    
    @IBOutlet weak var memoBackdropImageView: UIImageView!
    
    var index: Int?
    var movieData = [MovieData.Results]()
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = index {
            MovieDataSource.shared.loadImage(from: movieData[index].backdropPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                if let img = img {
                    self.memoBackdropImageView.image = img
                } else {
                    self.memoBackdropImageView.image = UIImage(named: "Default Image")
                }
            }
            
        }
    }
}
