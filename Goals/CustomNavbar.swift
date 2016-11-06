//
//  CustomNavbar.swift
//  Goals
//
//  Created by James Brown on 11/6/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class CustomNavbar: UINavigationBar {

    override func awakeFromNib() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        
        frame = frame.offsetBy(dx: 0, dy: 100)
    }
}
