//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/09/14.
//

import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit


/// 메모 작성 화면
class MemoViewController: UIViewController {
    
    /// 메모 텍스트뷰
    @IBOutlet weak var memoTextView: UITextView!
    
    /// 메모 플레이스홀더 레이블
    @IBOutlet weak var memoPlaceholderLabel: UILabel!
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 메모 텍스트
    ///
    /// 이전 화면에서 전달됩니다.
    var text: String?
    
    
    /// 이전 화면으로 돌아갑니다.
    /// - Parameter sender: X 버튼
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 작성한 메모가 이전 화면 메모 텍스트뷰에 들어갑니다.
    /// - Parameter sender: 확인 버튼
    @IBAction func saveMemo(_ sender: Any) {
        guard let memoText = memoTextView.text else { return }
        NotificationCenter.default.post(name: .memoDidSaved,
                                        object: nil,
                                        userInfo: [NotificationUserInfoKey.memo.rawValue: memoText])
        
        close(self)
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.becomeFirstResponder()
        
        let memoObservable = Observable.just(text)
        
        if text != nil {
            memoObservable
                .bind(to: memoTextView.rx.text)
                .disposed(by: rx.disposeBag)
            
            memoPlaceholderLabel.isHidden = true
        }
        
        let willShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height }
        
        let willHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
            .map { _ in CGFloat(0) }

        Observable.merge(willShow, willHide)
            .asDriver(onErrorJustReturn: 0)
            .drive(memoTextView.rx.keyboardHeight)
            .disposed(by: rx.disposeBag)
    }
}



/// 메모를 입력했을 때 발생하는 이벤트 처리
extension MemoViewController: UITextViewDelegate {
    
    /// 메모를 입력하면 플레이스 홀더 레이블을 숨깁니다.
    /// - Parameter textView: 메모 텍스트뷰
    func textViewDidChange(_ textView: UITextView) {
        memoPlaceholderLabel.isHidden = textView.hasText
    }
}
