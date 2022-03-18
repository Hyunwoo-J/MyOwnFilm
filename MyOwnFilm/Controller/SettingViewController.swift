//
//  SettingViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2022/03/18.
//

import NSObject_Rx
import RxSwift
import UIKit


/// 설정 화면
class SettingViewController: CommonViewController {
    
    /// 로그아웃합니다.
    /// - Parameter sender: 로그아웃 버튼
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "로그아웃", style: .default) { _ in
            DispatchQueue.main.async {
                LoginDataManager.shared.loginKeychain.clear()
                
                self.goToIntro()
            }
        }
        alert.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    /// 인트로 화면으로 돌아갑니다.
    private func goToIntro() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
                self.show(vc, sender: nil)
            }
        }
    }
}



/// 설정 화면 테이블뷰 데이터 관리
extension SettingViewController: UITableViewDataSource {
    
    /// 섹션 행의 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 설정 화면 데이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /// 로그아웃 버튼을 표시하는 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 설정 화면 테이블뷰
    ///   - indexPath: 섹션 인덱스
    /// - Returns: 구성한 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        return cell
    }
}
