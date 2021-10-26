//
//  CommonViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/06/04.
//

import Loaf
import UIKit


/// 공통적인 기능을 구현
class CommonViewController: UIViewController {
    
    /// window에 추가할 DimView
    ///
    /// 새로운 화면 뒤에 깔리는 화면을 어둡게 보이게 하기 위해서 만든 속성입니다.
    lazy var dimView: UIView = {
        let v = UIView()
        v.frame = self.view.bounds
        v.backgroundColor = .black
        v.alpha = 0.6
        
        return v
    }()
    
    /// 노티피케이션 옵저버 토큰
    var token: NSObjectProtocol?
    
    /// 노티피케이션 옵저버 토큰 배열
    var tokens = [NSObjectProtocol]()
    
    
    /// 경고창을 출력합니다.
    /// - Parameters:
    ///   - title: 경고창 타이틀
    ///   - message: 경고창 내용
    ///   - actionTitle: 액션 타이틀
    ///   - actionStyle: 액션 스타일
    func alertMessage(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// window에 추가된 DimView를 제거합니다.
    func removeDimViewFromWindow() {
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        for view in window.subviews as [UIView] where view == dimView {
            view.removeFromSuperview()
            break
        }
    }
    
    
    /// Loaf 경고 메시지를 출력합니다.
    /// - Parameters:
    ///   - message: 출력할 메시지
    ///   - duration: 메시지 출력 시간
    func alertLoafMessage(message: String, duration: Loaf.Duration) {
        let loaf = Loaf(message, state: .warning, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
        
        loaf.show(duration)
    }
    
    
    deinit {
        print(#function, self) // self: 현재 인스턴스 정보
        
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
        
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
