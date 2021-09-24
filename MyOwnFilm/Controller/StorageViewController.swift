//
//  StorageViewController.swift
//  StorageViewController
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit

class StorageViewController: CommonViewController {
    var isRecentlyMovieButtonSelected = false
    
    @IBOutlet weak var storageCollectionView: UICollectionView!
    @IBOutlet weak var recentlyMovieButton: UIButton!
    @IBOutlet weak var recentlyMovieBottomView: UIView!
    @IBOutlet weak var allMovieBottomView: UIView!
    @IBOutlet weak var allMovieButton: UIButton!
    
    @IBAction func movieButtonTapped(_ sender: UIButton) {
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
    
    
    @IBAction func alignmentButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openingYearAction = UIAlertAction(title: "개봉연도", style: .default) { act in
            MovieReview.movieReviewList.sort { $0.releaseDate > $1.releaseDate }
            self.storageCollectionView.reloadData()
        }
        alert.addAction(openingYearAction)
        
        let dateAction = UIAlertAction(title: "내가 본 날짜", style: .default) { act in
            MovieReview.movieReviewList.sort { $0.date > $1.date }
            
            self.storageCollectionView.reloadData()
        }
        alert.addAction(dateAction)
        
        let movieNameAction = UIAlertAction(title: "영화 이름", style: .default) { act in
            MovieReview.movieReviewList.sort { $0.movieTitle < $1.movieTitle }
            self.storageCollectionView.reloadData()
        }
        alert.addAction(movieNameAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        storageCollectionView.backgroundColor = .darkGray
        
        
        
        NotificationCenter.default.addObserver(forName: .memoWillCancelled, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            
            /// DimView 제거
            UIView.animate(withDuration: 0.3) {
                self.removeViewFromWindow()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
        storageCollectionView.reloadData()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if storageCollectionView != nil {
            storageCollectionView.reloadData()
        }
    }
}



extension StorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isRecentlyMovieButtonSelected {
            return MovieReview.recentlyMovieReviewList.count
        }
        
        return MovieReview.movieReviewList.count
    }
    
    
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MemoViewController") as? ReviewViewController {
            guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
            window.addSubview(self.dimView)
            
            vc.movieData = MovieReview.movieReviewList[indexPath.row]
            
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}



extension StorageViewController: UICollectionViewDelegateFlowLayout {
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
