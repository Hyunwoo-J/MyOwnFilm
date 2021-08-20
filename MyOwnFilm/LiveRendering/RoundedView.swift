//
//  RoundedView.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/17.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    /// - Parameter frame: 뷰의 CGRect
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    /// View의 cornerRadius를 둥글게 깎습니다.
    func setup() {
        layer.cornerRadius = frame.height / 2
    }
    
    
    /// Called when a designable object is created in Interface Builder.
    override func prepareForInterfaceBuilder() {
        setup()
    }
}
