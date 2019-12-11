//
//  ViewController.swift
//  PMHelper
//
//  Created by aziz on 06/12/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddTaskPage: UIViewController {

    @IBOutlet weak var nameOfTaskTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var durationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        
        if nameOfTaskTextField.text != "" && durationTextField.text != "" {
            
        saveInModel()
        }
    }
    
    func saveInModel() {
        var newId: Int16 = 1
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count != 0 {
                newId += result.last!.taskID
            }
        }
        let taskToSave = Task(context: DataController.shared.viewContext)
        taskToSave.taskID = newId
        taskToSave.taskName = nameOfTaskTextField.text
        taskToSave.duration = durationTextField.text
        
        let startDate = stripDate(date: datePicker.date)
        taskToSave.startDate = startDate
        
        let finishDate = calculateDateDaysAndStrip(date: datePicker.date, duration: Int(durationTextField.text!)!)
        taskToSave.finishDate = finishDate
        
        try? DataController.shared.viewContext.save()
        
        self.dismiss(animated: true, completion: nil)
        print(taskToSave)
    }
    
    func calculateDateDaysAndStrip(date: Date, duration: Int) -> String {
        
        let daysToAdd = duration
        
        let calcDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: date)
        let newDate = stripDate(date: calcDate!)
        
        return newDate
    }
    
    func stripDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: date)
        
        return newDate
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
