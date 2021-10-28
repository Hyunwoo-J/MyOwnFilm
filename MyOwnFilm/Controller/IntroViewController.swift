//
//  IntroViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/28.
//

import UIKit


class IntroViewController: CommonViewController {

    func validateToken() {
        guard let url = URL(string: "https://mofapi.azurewebsites.net/validation") else {
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: AccountKeys.apiToken.rawValue) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        let task = session.dataTask(with: request) { data, response, error in
            if let code = (response as? HTTPURLResponse)?.statusCode, code == 200 {
                self.goToMain()
            } else {
                self.goToLogin()
            }
        }
        task.resume()
    }
    
    
    private func goToLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = UserDefaults.standard.string(forKey: AccountKeys.userId.rawValue),
            let _ = UserDefaults.standard.string(forKey: AccountKeys.apiToken.rawValue) {
            validateToken()
        } else {
            goToLogin()
        }
    }
}
