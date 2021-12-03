//
//  CommonViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/06/04.
//

import KeychainSwift
import Loaf
import NSObject_Rx
import RxCocoa
import RxSwift
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
    
    /// 로그인 키체인 인스턴스
    let loginKeychain = KeychainSwift()
    
    
    /// 경고창을 출력합니다.
    /// - Parameters:
    ///   - title: 경고창 타이틀
    ///   - message: 경고창 내용
    ///   - actionTitle: 액션 타이틀
    ///   - actionStyle: 액션 스타일
    func showAlertMessage(title: String = "알림", message: String, actionTitle: String = "확인", actionStyle: UIAlertAction.Style = .default) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
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
    
    
    /// 메인 화면으로 이동합니다.
    func goToMain() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "mainSegue", sender: nil)
        }
    }
    
    
    /// 로그인 화면으로 이동합니다.
    func goToLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    
    deinit {
        print(#function, self) // self: 현재 인스턴스 정보
    }
}



/// Rx로 경고창 구현
extension CommonViewController {
    
    /// 경고창을 출력합니다.
    /// - Parameters:
    ///   - message: 경고창 내용
    /// - Returns: ActionType을 방출하는 옵저버블
    func showAlertMessageWithRx(message: String) -> Observable<ActionType> {
        return Observable<ActionType>.create { observer in
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                observer.onNext(.ok)
                observer.onCompleted()
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    /// 두 가지 액션이 있는 경고창을 출력합니다.
    /// - Parameters:
    ///   - alertTitle: 경고창 타이틀
    ///   - message: 경고창 내용
    ///   - okActionTitle: 확인 액션 타이틀
    ///   - okActionStyle: 확인 액션 스타일
    /// - Returns: ActionType을 방출하는 옵저버블
    func showTwoActionAlertMessageWithHandler(alertTitle: String, message: String, okActionTitle: String, okActionStyle: UIAlertAction.Style) -> Observable<ActionType> {
        return Observable<ActionType>.create { observer in
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                observer.onNext(.cancel)
                observer.onCompleted()
            }
            alert.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: okActionTitle, style: okActionStyle) { _ in
                observer.onNext(.ok)
                observer.onCompleted()
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
