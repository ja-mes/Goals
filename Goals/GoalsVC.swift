//
//  GoalsVC.swift
//  Goals
//
//  Created by James Brown on 11/6/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit
import CoreData

class GoalsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Goal>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell {
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func configureCell(cell: GoalCell, indexPath: IndexPath) {
        let goal = controller.object(at: indexPath)
        cell.nameLbl.text = goal.name
        cell.dateLbl.text = String(describing: goal.date)
    }


}

