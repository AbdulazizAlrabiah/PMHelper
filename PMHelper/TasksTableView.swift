//
//  TasksTableView.swift
//  PMHelper
//
//  Created by aziz on 06/12/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TasksTableView: UIViewController {
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    var kindOfView: Int!
    var tasks: [Task] = []
    var resources: [Resource] = []
    var count: Int = 0
    var relations: [Relation] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .landscapeRight
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayToSpecifiedButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    func displayToSpecifiedButton() {
        
        switch kindOfView {
        case 0:
            zero()
            break
        case 1:
            one()
            break
        case 2:
            twoNThree()
            break
        case 3:
            twoNThree()
            break
        case .none:
            return
        case .some(_):
            return
        }
}

    func zero() {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count != 0 {
                tasks = result
            }
        }
    }
    
    func one() {
        
        let fetchRequest: NSFetchRequest<Resource> = Resource.fetchRequest()
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count != 0 {
                resources = result
            }
        }
    }
    
    func cellOne(_ cell: TasksTableViewCell, _ indexPath: IndexPath) {
        
        cell.label1.text = resources[indexPath.row].resourceName
        cell.label2.text = resources[indexPath.row].type
        cell.label3.text = resources[indexPath.row].material
        cell.label4.text = String(resources[indexPath.row].max)
        cell.label5.text = String(resources[indexPath.row].rate)
        
        let textLabel = UILabel()
        textLabel.text  = String(resources[indexPath.row].overtime)
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5
        
        let textLabel2 = UILabel()
        textLabel2.text  = String(resources[indexPath.row].costUse)
        textLabel2.textAlignment = .center
        textLabel2.adjustsFontSizeToFitWidth = true
        textLabel2.minimumScaleFactor = 0.5
        
        cell.cellStackView.addArrangedSubview(textLabel)
        cell.cellStackView.addArrangedSubview(textLabel2)
        
        label1.text = "Resource Name"
        label2.text = "Type"
        label3.text = "Material"
        label4.text = "Max"
        label5.text = "St.Rate"
        
        if count == 0 {
            let textLabel3 = UILabel()
            textLabel3.text  = "Ovt."
            textLabel3.textAlignment = .center
            textLabel3.adjustsFontSizeToFitWidth = true
            textLabel3.minimumScaleFactor = 0.5
            
            let textLabel4 = UILabel()
            textLabel4.text  = "Cost/Use"
            textLabel4.textAlignment = .center
            textLabel4.adjustsFontSizeToFitWidth = true
            textLabel4.minimumScaleFactor = 0.5
            
            labelStackView.addArrangedSubview(textLabel3)
            labelStackView.addArrangedSubview(textLabel4)
        }
        count += 1
    }
    
    func twoNThree() {
        
        let fetchRequest: NSFetchRequest<Relation> = Relation.fetchRequest()
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count != 0 {
                relations = result
            }
        }
    }
    
    func cellTwo(_ cell: TasksTableViewCell, indexPath: IndexPath) {
        
        cell.label1.text = String(relations[indexPath.row].toTask!.taskID)
        cell.label2.text = relations[indexPath.row].toTask?.taskName
        cell.label3.text = relations[indexPath.row].toTask?.duration
        cell.label4.text = relations[indexPath.row].toTask?.startDate
        cell.label5.text = relations[indexPath.row].toTask?.finishDate
        
        let textLabel = UILabel()
        textLabel.text  = relations[indexPath.row].toResource?.resourceName
        textLabel.textAlignment = .center
        textLabel.minimumScaleFactor = 0.5
        textLabel.adjustsFontSizeToFitWidth = true
        cell.cellStackView.addArrangedSubview(textLabel)
        
        if count == 0 {
            let textLabel3 = UILabel()
            textLabel3.text  = "Resource Name"
            textLabel3.textAlignment = .center
            textLabel3.adjustsFontSizeToFitWidth = true
            textLabel3.minimumScaleFactor = 0.5
            
            labelStackView.addArrangedSubview(textLabel3)
        }
        count += 1
    }
    
    func cellThree(_ cell: TasksTableViewCell, _ indexPath: IndexPath) {
        
        cell.label1.text = String(relations[indexPath.row].toTask!.taskID)
        cell.label2.text = relations[indexPath.row].toTask?.taskName
        cell.label3.text = relations[indexPath.row].toTask?.duration
        cell.label4.text = relations[indexPath.row].toTask?.startDate
        cell.label5.text = relations[indexPath.row].toTask?.finishDate
        
        let textLabel = UILabel()
        textLabel.text  = relations[indexPath.row].toResource?.resourceName
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5
        
        let totalCost = Int(cell.label3.text!)! * 8 * Int(relations[indexPath.row].toResource!.rate)
        
        let textLabel2 = UILabel()
        textLabel2.text  = String("\(totalCost)$")
        textLabel2.textAlignment = .center
        textLabel2.adjustsFontSizeToFitWidth = true
        textLabel2.minimumScaleFactor = 0.5
        
        cell.cellStackView.addArrangedSubview(textLabel)
        cell.cellStackView.addArrangedSubview(textLabel2)
        
        if count == 0 {
            let textLabel3 = UILabel()
            textLabel3.text  = "Resource Name"
            textLabel3.textAlignment = .center
            textLabel3.adjustsFontSizeToFitWidth = true
            textLabel3.minimumScaleFactor = 0.5
            
            let textLabel4 = UILabel()
            textLabel4.text  = "Total Cost"
            textLabel4.textAlignment = .center
            textLabel4.adjustsFontSizeToFitWidth = true
            textLabel4.minimumScaleFactor = 0.5
            
            labelStackView.addArrangedSubview(textLabel3)
            labelStackView.addArrangedSubview(textLabel4)
        }
        count += 1
    }
}
extension TasksTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kindOfView {
        case 0:
            return tasks.count
        case 1:
            return resources.count
        case 2:
            return relations.count
        case 3:
            return relations.count
        case .none:
            return 0
        case .some(_):
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rows") as! TasksTableViewCell
        
        switch kindOfView {
        case 0:
            cell.label1.text = String(tasks[indexPath.row].taskID)
            cell.label2.text = tasks[indexPath.row].taskName
            cell.label3.text = tasks[indexPath.row].duration
            cell.label4.text = tasks[indexPath.row].startDate
            cell.label5.text = tasks[indexPath.row].finishDate
            
            return cell
        case 1:
            cellOne(cell, indexPath)
            return cell
        case 2:
            cellTwo(cell, indexPath: indexPath)
            return cell
        case 3:
            cellThree(cell, indexPath)
            return cell
        case .none:
            return cell
        case .some(_):
            return cell
        }
    }
    
        
}

//    func generateString() -> String? {
//        var resultString: String?
//
//        let firstString = "<DOCTYPE HTML> \r <html lang=\"en\" \r <head> \r <meta charset = \"utf-8\"> \r </head> \r <body> <table><tr><th>Id</th><th>Name</th><th>Duration</th><th>Start</th><th>Finish</th></tr> <tr><td>John</td><td>Appleseed</td><td>5</td><td>1/1/1</td><td>2/2/2</td></tr></table>"
//        let endString = "</body> \r </html>";
//        resultString = firstString + endString;
//
//        return resultString
//    }
//extension String {
//
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return NSAttributedString() }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return NSAttributedString()
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}
//        let testString = generateString()
//        textView.attributedText = testString?.htmlToAttributedString
//        var screenWidth = UIScreen.main.bounds.width
