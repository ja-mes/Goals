//
//  AddVC.swift
//  Goals
//
//  Created by James Brown on 11/6/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class AddVC: UIViewController {

    @IBOutlet weak var name: CustomField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var color: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIButton) {
        if let goal = configure() {
            goal.date = datePicker.date as NSDate?
            
            if let color = color {
                goal.color = color
            } else {
                goal.color = ""
            }
            
            appDel.saveContext()
            
            dismiss(animated: true, completion: nil)
        } else {
            displayAlert(title: "Oops!", message: "You forgot to fill out the name field")
        }
    }
    
    @IBAction func colorPressed(_ sender: UIButton) {
        if let color = sender.backgroundColor {
            self.color = color.toHexString()
            
            print(color.toHexString())
        }
    }
    
    
    func configure() -> Goal? {
        if let text = name.text, text.isEmpty == false {
            let goal = Goal(context: context)
            goal.name = text
            
            return goal
        }
        
        return nil
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
