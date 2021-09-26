//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/09/14.
//

import UIKit


/// 메모를 작성하는 화면과 관련된 뷰컨트롤러 클래스
class MemoViewController: UIViewController {
    /// 메모를 작성할 텍스트뷰
    @IBOutlet weak var memoTextView: UITextView!
    
    
    /// X 버튼을 누르면 이전 화면으로 돌아갑니다.
    /// - Parameter sender: X 버튼
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 화면에 진입했을 때 키보드 올리기
        memoTextView.becomeFirstResponder()
    }
}
