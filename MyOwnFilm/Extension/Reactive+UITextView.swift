//
//  Reactive+UITextView.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/11/14.
//

import Foundation
import RxSwift


extension Reactive where Base: UITextView {
    
    /// 텍스트뷰 contentInset과 scrollIndicatorInsets의 bottom을 옵저버블이 방출하는 CGFloat 값으로 지정
    var keyboardHeight: Binder<CGFloat> {
        return Binder(self.base) { textView, height in
            UIView.animate(withDuration: 0.3) {
                var inset = textView.contentInset
                inset.bottom = height
                textView.contentInset = inset
                
                inset = textView.scrollIndicatorInsets
                inset.bottom = height
                textView.scrollIndicatorInsets = inset
            }
        }
    }
}
