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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIButton) {
        let goal = Goal(context: context)

        if configure(goal: goal) {
            goal.date = datePicker.date as NSDate?
            goal.color = "exampleColor"
            
            appDel.saveContext()
            
            dismiss(animated: true, completion: nil)
        } else {
            if goal.objectID.isTemporaryID {
                context.delete(goal)
            }
        }
    }
    
    func configure(goal: Goal) -> Bool {
        if let text = name.text, text.isEmpty == false {
            goal.name = text
            
            return true
        }
        
        return false
    }
}
