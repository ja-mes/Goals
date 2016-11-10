//
//  CustomField.swift
//  Goals
//
//  Created by James Brown on 11/9/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class CustomField: UITextField {

    override func awakeFromNib() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftView = paddingView
        leftViewMode = UITextFieldViewMode.always
    }
}
