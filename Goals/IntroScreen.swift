////
////  IntroScreen.swift
////  Goals
////
////  Created by James Brown on 11/17/16.
////  Copyright © 2016 James Brown. All rights reserved.
////
//
//import Foundation
//import EAIntroView
//
//class Intro {
//    static let shared = Intro()
//    
//    func show(view: UIView) {
//        // basic
//        var page1 = EAIntroPage()
//        page1.title = "Hello world"
//        page1.desc = sampleDescription1
//        // custom
//        var page2 = EAIntroPage()
//        page2.title = "This is page 2"
//        page2.titleFont = UIFont(name: "Georgia-BoldItalic", size: 20)
//        page2.titlePositionY = 220
//        page2.desc = sampleDescription2
//        page2.descFont = UIFont(name: "Georgia-Italic", size: 18)
//        page2.descPositionY = 200
//        page2.titleIconView = UIImageView(image: UIImage(named: "title2")!)
//        page2.titleIconPositionY = 100
//        // custom view from nib
//        var page3 = EAIntroPage(customViewFromNibNamed: "IntroPage")
//        page3?.bgImage = UIImage(named: "bg2")!
//        // PART 2
//        var intro = EAIntroView(frame: view.bounds, andPages: [page1, page2, page3, page1])
//        intro?.delegate = self
//        // PART 3
//        intro?.show(in: view, animateDuration: 0.0)
//
//    }
//}
