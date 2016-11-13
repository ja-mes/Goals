//
//  AddVC.swift
//  Goals
//
//  Created by James Brown on 11/6/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class AddVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: CustomField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var goal: Goal?
    var color: String?
    var selectedColor: CircleButton?
    @IBOutlet var colorButtons: [UIButton]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        name.delegate = self
        
        if let goal = goal {
            name.text = goal.name
            
            if let date = goal.date as? Date {
                datePicker.setDate(date, animated: true)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    @IBAction func colorPressed(_ sender: CircleButton) {
        if let color = sender.backgroundColor {
            self.color = color.toHexString()
            
            sender.selectedColor = true
            
            if let currentColor = selectedColor {
                currentColor.selectedColor = false
            }
            
            selectedColor = sender
        }
    }
    
    
    func configure() -> Goal? {
        if let text = name.text, text.isEmpty == false {
            let item: Goal!
            
            if let goal = goal {
                item = goal
            } else {
                item = Goal(context: context)
            }
            
            item.name = text
            
            return item
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
