//
//  AddResourcesToTaskPage.swift
//  PMHelper
//
//  Created by aziz on 06/12/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddResourcesToTaskPage: UIViewController {
    
    @IBOutlet weak var idOfTaskTextField: UITextField!
    @IBOutlet weak var tableView1: UITableView!
    
    var taskId: Int!
    var resourcesToDisplay: [Resource] = []
    var resourcesToSave: [Resource] = []
    var indexes: [Int] = []
    var task: Task!
    var resourceToAssign: Relation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addResourcesButtonPressed(_ sender: Any) {
        
        for (index, resource) in resourcesToDisplay.enumerated() {
            
            if (tableView1.cellForRow(at: IndexPath(indexes: [0,index]))!.isHighlighted) {
                resourcesToSave.append(resource)
            }
        }
        
        if idOfTaskTextField.text != "" && resourcesToSave.count > 0 {
            
            for (index, resource) in resourcesToSave.enumerated() {
                resourceToAssign = Relation(context: DataController.shared.viewContext)
                resourceToAssign.resourceID = resource.resourceID
                resourceToAssign.taskID = Int16(taskId)
                resourceToAssign.toResource = resource
                resourceToAssign.toTask = task
                
                try? DataController.shared.viewContext.save()
            }
            self.dismiss(animated: true, completion: nil)
        }
//        if idOfTaskTextField.text != "" && resourcesToSave.count > 0 {
//        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "taskID == \(Int16(taskId))")
//        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
//            if result.count != 0 {
//                task = result[0]
//                task.value(forKey: "resource")
//               // let new = task.resource?.allObjects as! [Resource]
//                // print(new)
//                print(task.resource?.count)
//                for resource in resourcesToSave {
//                //    task.addToResource(resource)
//                }
//                print(task.resource?.count)
//                try! DataController.shared.viewContext.save()
//                self.dismiss(animated: true, completion: nil)
//                }
//            }
//        }
    }
    
    @IBAction func cacnelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchAndDisplayResources(task: Task) {
        //ANY task.taskID == \(task.taskID)
        
        //        let predicate = NSPredicate(format: "ANY task.taskID != \(Int16(taskId)) || ANY task = %@",0)
        //let predicate = NSPredicate(format: "NOT (task.taskID CONTAINS[cd] %@)", task)
        //let predicate = NSPredicate(format: , )
        
        let fetchRequest: NSFetchRequest<Relation> = Relation.fetchRequest()
        let predicate = NSPredicate(format: "taskID == \(taskId!)")
        print(predicate)
        fetchRequest.predicate = predicate
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count != 0 {
                print(result.count)
                var subPredicates : [NSPredicate] = []
                for resourceID in result {
                    let subPredicate = NSPredicate(format: "resourceID != \(resourceID.resourceID)" )
                    subPredicates.append(subPredicate)
                    //print(resourceID)
                }
            let fetchRequest2: NSFetchRequest<Resource> = Resource.fetchRequest()
//                fetchRequest2.predicate = NSPredicate(format: "resourceID != %@", argumentArray: integers)
                fetchRequest2.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
                if let result2 = try? DataController.shared.viewContext.fetch(fetchRequest2) {
                    print(result2.count)
                    resourcesToDisplay = result2
                }
            } else {
                print("fail")
                let fetchRequest: NSFetchRequest<Resource> = Resource.fetchRequest()
               // let predicate = NSPredicate(format: "toTask != %@", task)
                 if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
                    resourcesToDisplay = result
                }
            }
        }
        guard resourcesToDisplay.isEmpty else {
            tableView1.reloadData()
            return
        }
    }
    
    func fillResourcesWithID() {

            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "taskID == \(Int16(taskId))")
            if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
                if result.count != 0 {
                    task = result[0]
                    task.value(forKey: "resource")
                    searchAndDisplayResources(task: task)
            }
        }
    }
}
extension AddResourcesToTaskPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourcesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "test")
        
        cell?.textLabel?.text = resourcesToDisplay[indexPath.row].resourceName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView1.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
        //resourcesToSave.append(resourcesToDisplay[indexPath.row])
        //indexes.append(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView1.cellForRow(at: indexPath)!.setHighlighted(false, animated: true)
 //       let index: Int = indexes.firstIndex(of: indexPath.row)!
        
//        indexes.remove(at: index)
//        resourcesToSave.remove(at: index)
        //print(resourcesToSave)
    }
    
}
extension AddResourcesToTaskPage: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
         resourcesToDisplay = []
         resourcesToSave = []
         indexes = []
        tableView1.reloadData()
        
        if textField.returnKeyType == UIReturnKeyType.go && textField.text != "" {
            taskId = Int(textField.text!)!
            //searchAndDisplayResources()
            fillResourcesWithID()
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}
