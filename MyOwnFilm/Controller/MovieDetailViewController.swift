//
//  MovieDetailViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/06.
//

import UIKit

class MovieDetailViewController: CommonViewController {
    
    @IBOutlet weak var backgroundmovieImage: UIImageView!
    
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 이전 화면에서의 데이터를 가져오기 위한 변수
    var index: Int?
    var image: UIImage?
    var movieData = [MovieData.Results]()
    
    
    /// 상태바를 흰색으로 바꾸기 위해 추가한 메소드
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MemoViewController {
            vc.index = index
            vc.movieData = movieData
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = image {
            backgroundmovieImage.image = image
        } else {
            backgroundmovieImage.image = UIImage(named: "Default Image")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 백그라운드, 텍스트, 버튼 컬러 변경
        view.backgroundColor = .black
        
        [storyLabel, titleLabel, dateLabel].forEach { $0?.textColor = .white }
        
        
        
        if let index = index {
            storyLabel.text = movieData[index].overviewStr
            titleLabel.text = movieData[index].titleStr
            dateLabel.text = movieData[index].releaseDate
        }
        
        
        
        
        
    }
}




