//
//  MainViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/03.
//

import UIKit

class MainViewController: CommonViewController {
        
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let indexPath = movieCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? MovieDetailViewController {
                vc.index = indexPath.row
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        movieCollectionView.alpha = 0.0
        
        MovieDataSource.shared.fetchMovie {
            self.movieCollectionView.reloadData()
            
            UIView.animate(withDuration: 0.3) {
                self.movieCollectionView.alpha = 1.0
            }
            
            self.imageLoader.stopAnimating()
        }
    }
}





extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieDataSource.shared.movieList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainMovieImageCollectionViewCell", for: indexPath) as! MainMovieImageCollectionViewCell
        
        let index = MovieDataSource.shared.movieList[indexPath.row]
        
        cell.configure(with: index)
        
            
        return cell
    }
}




extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
        
        //        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
//            return .zero
//        }
//
//        let width = (collectionView.frame.width - (layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing))
//        let height = (collectionView.frame.height - (layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumInteritemSpacing))
//
//        return CGSize(width: width, height: height)
    }
}

