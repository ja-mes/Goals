//
//  CircleView.swift
//  Goals
//
//  Created by James Brown on 11/10/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class CircleView: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width / 2
    }
}
