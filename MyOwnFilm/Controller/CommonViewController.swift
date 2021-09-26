//
//  CommonViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/06/04.
//

import UIKit


/// 공통적인 기능을 구현하는 뷰컨트롤러 클래스
class CommonViewController: UIViewController {
    /// window에 추가할 DimView
    lazy var dimView: UIView = {
        let v = UIView()
        v.frame = self.view.bounds
        v.backgroundColor = .black
        v.alpha = 0.6
        
        return v
    }()
    
    
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
    
    
    /// window에 추가된 DimView를 제거합니다.
    func removeViewFromWindow() {
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        for view in window.subviews as [UIView] where view == dimView {
            view.removeFromSuperview()
            break
        }
    }
    
    
    deinit {
        print(#function, self) // self: 현재 인스턴스 정보
    }
}
