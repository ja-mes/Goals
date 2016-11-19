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
    @IBOutlet var colorButtons: [CircleButton]!
    @IBOutlet weak var dateField: CustomField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: RoundedButton!
    @IBOutlet weak var markAsDoneButton: RoundedButton!
    
    var goal: Goal?
    var color: String?
    var datePicker: UIDatePicker!
    var oldSelectedColor: CircleButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        name.delegate = self
        
        // datepicker field
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateField.inputView = datePicker
        dateField.tintColor = UIColor.clear
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        
        if let goal = goal {
            titleLabel.text = "EDIT"
            name.text = goal.name
            deleteButton.isHidden = false
            markAsDoneButton.isHidden = false
            
            if let date = goal.date as? Date {
                datePicker.setDate(date, animated: true)
                displayDate(date: date)
            }
            
            
            for button in colorButtons {
                if let color = button.backgroundColor?.toHexString(), let selectedColor = goal.color {
                    if color == selectedColor {
                        colorPressed(button)
                    }
                }
            }
            
        } else {
            colorPressed(colorButtons[0])
            displayDate(date: Date())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func dateEditingBegan(_ sender: CustomField) {
        dateField.textColor = #colorLiteral(red: 1, green: 0.1558659971, blue: 0.145486623, alpha: 1)
    }
    
    @IBAction func dateEditingEnded(_ sender: CustomField) {
        dateField.textColor = .black
    }
    
    @IBAction func nameChanged(_ sender: CustomField) {
        if let text = sender.text?.characters, text.count > 30 {
            sender.text?.remove(at: text.index(before: text.endIndex))
        }
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
    
    @IBAction func deletePressed(_ sender: RoundedButton) {
        if let goal = goal {
            let deleteAlert = UIAlertController(title: "Are you sure?", message: "This goal will be permanently deleted", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                context.delete(goal)
                appDel.saveContext()
                self.dismiss(animated: true, completion: nil)
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func colorPressed(_ sender: CircleButton) {
        if let color = sender.backgroundColor {
            
            self.color = color.toHexString()
            
            sender.selectedColor = true
            
            if let currentColor = oldSelectedColor {
                currentColor.selectedColor = false
            }
            
            oldSelectedColor = sender
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
    
    func handleDatePicker(sender: UIDatePicker) {
        displayDate(date: sender.date)
    }
    
    func displayDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateField.text = dateFormatter.string(from: date).uppercased()
    }
}

















