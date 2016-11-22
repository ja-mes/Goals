//
//  GoalsVC.swift
//  Goals
//
//  Created by James Brown on 11/6/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit
import CoreData
import EAIntroView

class GoalsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, EAIntroDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentButton: RoundedButton!
    @IBOutlet weak var doneButton: RoundedButton!
    @IBOutlet weak var failedButton: RoundedButton!
    
    var controller: NSFetchedResultsController<Goal>!
    var selectedSegmentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                
        fetchGoals()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(notification:)), name: NSNotification.Name("reloadTableView"), object: nil)
        
        
        if UserDefaults.standard.object(forKey: "firstLaunch") == nil {
            let page1 = EAIntroPage()
            page1.title = "Swipe to continue"
            page1.titleFont = UIFont(name: "AvenirNext-Medium", size: 18)
            page1.titlePositionY = 100
            page1.titleIconView = UIImageView(image: #imageLiteral(resourceName: "Screen1"))
            page1.titleIconPositionY = 80
            page1.bgColor = #colorLiteral(red: 1, green: 0.1558659971, blue: 0.145486623, alpha: 1)
            page1.descFont = UIFont(name: "Avenir Next", size: 15)
            
            let page2 = EAIntroPage()
            page2.title = "Swipe to continue"
            page2.titleFont = UIFont(name: "AvenirNext-Medium", size: 18)
            page2.titlePositionY = 95
            page2.titleIconView = UIImageView(image: #imageLiteral(resourceName: "Screen2"))
            page2.titleIconPositionY = 80
            page2.bgColor = #colorLiteral(red: 1, green: 0.1558659971, blue: 0.145486623, alpha: 1)
            page2.descFont = UIFont(name: "Avenir Next", size: 15)
            
            let page3 = EAIntroPage()
            page3.title = "Swipe to continue"
            page3.titleFont = UIFont(name: "AvenirNext-Medium", size: 18)
            page3.titlePositionY = 95
            page3.titleIconView = UIImageView(image: #imageLiteral(resourceName: "Screen 3"))
            page3.titleIconPositionY = 80
            page3.bgColor = #colorLiteral(red: 1, green: 0.1558659971, blue: 0.145486623, alpha: 1)
            page3.descFont = UIFont(name: "Avenir Next", size: 15)
            
            let intro = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])
            
            intro?.delegate = self
            intro?.show(in: self.view, animateDuration: 0.0)
            
            UserDefaults.standard.set(true, forKey: "firstLaunch")
            
        }

        
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
                failedButton.backgroundColor = UIColor.white
                
                selectedSegmentIndex = 1
                
                
                fetchGoals()
                tableView.reloadData()
            }
        } else if sender == currentButton {
            if selectedSegmentIndex != 0 {
                doneButton.backgroundColor = UIColor.white
                failedButton.backgroundColor = UIColor.white
                currentButton.backgroundColor = UIColor(hexString: "#D6D6D6")
                
                selectedSegmentIndex = 0
                
                
                fetchGoals()
                tableView.reloadData()
            }
        } else if sender == failedButton {
            if selectedSegmentIndex != 2 {
                failedButton.backgroundColor = UIColor(hexString: "D6D6D6")
                currentButton.backgroundColor = UIColor.white
                doneButton.backgroundColor = UIColor.white
                
                selectedSegmentIndex = 2
                
                
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
        
        
        var displayedType = 0
        
        if selectedSegmentIndex == 1 {
            displayedType = 1
        } else if selectedSegmentIndex == 2 {
            displayedType = 2
        }
        
        fetchRequest.predicate = NSPredicate(format: "done == %@", "\(displayedType)" as CVarArg)
        
        
        
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
        }
        
        
        if let date = goal.date as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            cell.dateLbl.text = formatter.string(from: date)
            
            if Date().compare(date) == ComparisonResult.orderedDescending && selectedSegmentIndex == 0 {
                cell.pastDueIcon.isHidden = false
            } else {
                cell.pastDueIcon.isHidden = true
            }
        }
    }
    
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let goal = controller.object(at: indexPath)
                if goal.done == 0 {
                    goal.done = 1
                } else {
                    goal.done = 0
                }
                appDel.saveContext()
            }
        }
    }
    
    func reloadTableView(notification: Notification) {
        fetchGoals()
        tableView.reloadData()
    }
}

