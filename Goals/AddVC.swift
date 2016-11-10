//
//  AddVC.swift
//  Goals
//
//  Created by James Brown on 11/6/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class AddVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var name: CustomField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        //return cell
        
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIButton) {
        if let goal = configure() {
            goal.date = datePicker.date as NSDate?
            goal.color = "exampleColor"
            
            appDel.saveContext()
            
            dismiss(animated: true, completion: nil)
        } else {
            displayAlert(title: "Oops!", message: "You forgot to fill out the name field")
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
