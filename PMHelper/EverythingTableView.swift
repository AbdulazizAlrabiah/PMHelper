//
//  EverythingTableView.swift
//  PMHelper
//
//  Created by aziz on 11/12/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EverythingTableView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelStackView: UIStackView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var relations: [Relation] = []
    var count: Int = 0
    var totalCost = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .landscapeRight
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    func fetch() {
    
        let fetchRequest: NSFetchRequest<Relation> = Relation.fetchRequest()
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count != 0 {
                relations = result
            }
        }
    
    }
    
    func display(_ cell: TasksTableViewCell, _ indexPath: IndexPath) -> Int {
        
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
        return totalCost
    }
    
}
extension EverythingTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return relations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rows") as! TasksTableViewCell
        
        totalCost += display(cell, indexPath)
        totalCostLabel.text = String("\(totalCost)$")
        
        return cell
    }
}
