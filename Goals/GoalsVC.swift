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
    @IBOutlet weak var currentButton: RoundedButton!
    @IBOutlet weak var doneButton: RoundedButton!
    
    var controller: NSFetchedResultsController<Goal>!
    var selectedSegmentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                
        fetchGoals()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVC" {
            if let destination = segue.destination as? AddVC {
                if let goal = sender as? Goal {
                    destination.goal = goal
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell {
            configureCell(cell: cell, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddVC", sender: controller.object(at: indexPath))
    }
    
    // MARK: ibactions
    @IBAction func addGoalPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "AddVC", sender: nil)
    }
    
    
    @IBAction func segmentChanged(_ sender: RoundedButton) {
        if sender == doneButton {
            if selectedSegmentIndex != 1 {
                doneButton.backgroundColor = UIColor(hexString: "#D6D6D6")
                currentButton.backgroundColor = UIColor.white
                
                selectedSegmentIndex = 1
                fetchGoals()
                tableView.reloadData()
            }
        } else if sender == currentButton {
            if selectedSegmentIndex != 0 {
                doneButton.backgroundColor = UIColor.white
                currentButton.backgroundColor = UIColor(hexString: "#D6D6D6")
                
                selectedSegmentIndex = 0
                fetchGoals()
                tableView.reloadData()
            }
        }
    }
    

    
    // MARK: fetched results controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) as? GoalCell {
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func fetchGoals() {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        
        var shouldShowDone = true
        
        if selectedSegmentIndex == 0 {
            shouldShowDone = false
        }
        
        fetchRequest.predicate = NSPredicate(format: "done == %@", shouldShowDone as CVarArg)
        
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unable to fetch goals \(error)")
        }
    }
    
    
    func configureCell(cell: GoalCell, indexPath: IndexPath) {
        let goal = controller.object(at: indexPath)
        cell.nameLbl.text = goal.name?.uppercased()
        
        if let color = goal.color {
            cell.view.backgroundColor = UIColor(hexString: color)
    
            if selectedSegmentIndex == 1 {
                cell.view.backgroundColor = cell.view.backgroundColor?.withAlphaComponent(0.7)
            }
            
        }
        
        
        if let date = goal.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            cell.dateLbl.text = formatter.string(from: date as Date)
        }
    }
    
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let goal = controller.object(at: indexPath)
                goal.done = !goal.done
                appDel.saveContext()
            }
        }
    }


}

