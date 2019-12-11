//
//  AddResourcePage.swift
//  PMHelper
//
//  Created by aziz on 06/12/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddResourcePage: UIViewController {
    
    @IBOutlet weak var nameOfResourceTextField: UITextField!
    @IBOutlet weak var materialTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var overtimeTextField: UITextField!
    @IBOutlet weak var costNUseTextField: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    
    let typeArray = ["Work","Material","Cost"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addResourceButtonPressed(_ sender: Any) {
        
        if nameOfResourceTextField.text != "" && materialTextField.text != "" && maxTextField.text != "" && rateTextField.text != "" && overtimeTextField.text != "" && costNUseTextField.text != "" {
            saveInModel()
        }
    }
    
    func saveInModel() {
        
        var newId: Int16 = 1
        
        let fetchRequest: NSFetchRequest<Resource> = Resource.fetchRequest()
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count != 0 {
                newId += result.last!.resourceID
            }
        }
        
        let resourceToSave = Resource(context: DataController.shared.viewContext)
        resourceToSave.resourceID = newId
        resourceToSave.resourceName = nameOfResourceTextField.text
        resourceToSave.material = materialTextField.text
        resourceToSave.max = Int16(maxTextField.text!)!
        resourceToSave.rate = Int16(rateTextField.text!)!
        resourceToSave.costUse = Int16(costNUseTextField.text!)!
        resourceToSave.overtime = Int16(overtimeTextField.text!)!
        resourceToSave.type = typeArray[typePicker.selectedRow(inComponent: 0)]
        
        try? DataController.shared.viewContext.save()
        
        self.dismiss(animated: true, completion: nil)
        print(resourceToSave)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension AddResourcePage: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
}
