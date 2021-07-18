//
//  MovieDetailViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/06.
//

import UIKit

class MovieDetailViewController: CommonViewController {

    @IBOutlet weak var movieImage: UIImageView!
    
    
    var index: Int?
    
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    



}
