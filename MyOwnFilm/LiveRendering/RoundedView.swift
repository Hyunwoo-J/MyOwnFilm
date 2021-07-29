//
//  RoundedView.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/17.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        layer.cornerRadius = frame.height / 2
    }
    
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
}
