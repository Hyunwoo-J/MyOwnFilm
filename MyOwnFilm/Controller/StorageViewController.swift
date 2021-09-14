//
//  StorageViewController.swift
//  StorageViewController
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit

class StorageViewController: CommonViewController {
    @IBOutlet weak var storageCollectionView: UICollectionView!
    
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
}




extension StorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieReview.movieReviewList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorageCollectionViewCell", for: indexPath) as! StorageCollectionViewCell
        
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
        
        let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
        let height = width * 1.5
        
        return CGSize(width: Int(width), height: Int(height))
    }
}
