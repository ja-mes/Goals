//
//  CustomField.swift
//  Goals
//
//  Created by James Brown on 11/9/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

@IBDesignable class CustomField: UITextField {

    @IBInspectable var textPadding: CGFloat = 15 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: textPadding, height: frame.height))
            leftView = paddingView
            leftViewMode = UITextFieldViewMode.always
        }
    }
    
    override func awakeFromNib() {
        
    }
}
