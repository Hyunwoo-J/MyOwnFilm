//
//  SettingViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/28.
//

import UIKit

class SettingViewController: CommonViewController {

    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: AccountKeys.userId.rawValue)
        UserDefaults.standard.removeObject(forKey: AccountKeys.apiToken.rawValue)
        UserDefaults.standard.removeObject(forKey: AccountKeys.provider.rawValue)
        
        goToIntro()
    }
    
    
    private func goToIntro() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "introSegue", sender: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}



extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        return cell
    }
}
