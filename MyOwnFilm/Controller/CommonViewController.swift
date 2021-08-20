//
//  CommonViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/06/04.
//

import UIKit

// 공통적인 기능을 구현하는 컨트롤러
class CommonViewController: UIViewController {
    // TODO: 알러트 메서드, 백그라운드를 바꾸는 메서드 추가
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /// 경고창을 출력합니다.
    /// - Parameters:
    ///   - title: 경고창 타이틀
    ///   - message: 경고창 내용
    ///   - actionTitle: 액션 타이틀
    ///   - actionStyle: 액션 스타일
    func alertFunc(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    deinit {
        print(#function, self) // self: 현재 인스턴스 정보
    }
}
