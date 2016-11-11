//
//  CircleView.swift
//  Goals
//
//  Created by James Brown on 11/10/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    private var _selectedColor = false
    
    var selectedColor: Bool {
        get {
            return _selectedColor
        } set {
            _selectedColor = newValue
            awakeFromNib()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.size.width / 2
        
        if _selectedColor {
            layer.borderWidth = 3
            layer.borderColor = UIColor.darkGray.cgColor
        } else {
            layer.borderColor = nil
            layer.borderWidth = 0
        }

    }
}
