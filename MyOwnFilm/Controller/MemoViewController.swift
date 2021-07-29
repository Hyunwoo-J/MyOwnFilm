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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = index {
            MovieDataSource.shared.loadImage(from: MovieDataSource.shared.nowPlayingMovieList[index].backdropPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                if let img = img {
                    self.memoBackdropImageView.image = img
                } else {
                    self.memoBackdropImageView.image = UIImage(named: "Default Image")
                }
            }
            
        }
    }
}
