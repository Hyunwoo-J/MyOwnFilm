//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/09/14.
//

import UIKit


extension Notification.Name {
    /// 메모 확인 버튼을 누르면 보낼 노티피케이션
    static let memoDidSaved = Notification.Name(rawValue: "memoDidSaved")
}



/// 메모를 작성하는 화면과 관련된 뷰컨트롤러 클래스
class MemoViewController: UIViewController {
    /// 메모 텍스트뷰
    @IBOutlet weak var memoTextView: UITextView!
    
    /// 메모 플레이스홀더
    @IBOutlet weak var memoPlaceholderLabel: UILabel!
    
    /// X 버튼을 누르면 이전 화면으로 돌아갑니다.
    /// - Parameter sender: X 버튼
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 확인 버튼을 누르면 작성한 메모가 이전 화면 메모 텍스트뷰에 들어갑니다.
    /// - Parameter sender: 확인 버튼
    @IBAction func saveMemo(_ sender: Any) {
        guard let memoText = memoTextView.text else { return }
        NotificationCenter.default.post(name: .memoDidSaved, object: nil, userInfo: ["memo": memoText])
        
        close(self)
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.becomeFirstResponder()
    }
}



extension MemoViewController: UITextViewDelegate {
    /// 사용자가 텍스트뷰에서 텍스트 또는 속성을 변경할 때 델리게이트에게 알립니다.
    /// - Parameter textView: 이 메소드를 호출하는 텍스트뷰
    func textViewDidChange(_ textView: UITextView) {
        memoPlaceholderLabel.isHidden = textView.hasText
    }
}
