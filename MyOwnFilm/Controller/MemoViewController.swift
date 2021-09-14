//
//  MemoViewController.swift
//  MemoViewController
//
//  Created by Hyunwoo Jang on 2021/09/14.
//

import UIKit

class MemoViewController: UIViewController {
    /// <#Description#>
    @IBOutlet weak var memoTextView: UITextView!
    
    
    /// <#Description#>
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        memoTextView.becomeFirstResponder()
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
