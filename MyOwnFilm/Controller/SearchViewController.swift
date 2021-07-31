//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by Hyunwoo Jang on 2021/07/31.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    
    /// 상태바를 흰색으로 바꾸기 위해 추가한 메소드
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [view, movieTableView].forEach {
            $0?.backgroundColor = .black
        }
        
    }
    
    
}




extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieDataSource.shared.searchMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieTableViewCell", for: indexPath) as! SearchMovieTableViewCell
        
        let target = MovieDataSource.shared.searchMovieList[indexPath.row]
        cell.configure(with: target)
        
        
        
        return cell
    }
    
    
}



extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = indexPath.row
            
            print(vc)
            let searchMovieData = MovieDataSource.shared.searchMovieList[indexPath.row]
            MovieDataSource.shared.loadImage(from: searchMovieData.posterPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                if let img = img {
                    vc.image = img
                }
            }
            
            vc.movieData = MovieDataSource.shared.searchMovieList
            
            show(vc, sender: nil)
        }
            
    }
}




extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let hasText = searchBar.text else {
            return
        }
        
        MovieDataSource.shared.fetchQueryMovie(about: hasText) {
            self.movieTableView.reloadData()
        }
        
//        print(MovieDataSource.shared.searchMovieList)
    }
}
