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
    
    
    /// 상태바를 흰색으로 바꾸기 위해 추가한 메소드
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
