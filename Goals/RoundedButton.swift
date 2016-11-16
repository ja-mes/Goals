//
//  RoundedButton.swift
//  Goals
//
//  Created by James Brown on 11/15/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
