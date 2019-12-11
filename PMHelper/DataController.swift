//
//  DataController.swift
//  PMHelper
//
//  Created by aziz on 09/12/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    private let persistentContainer: NSPersistentContainer
    static let shared = DataController(modelName: "Model")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
   private init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
