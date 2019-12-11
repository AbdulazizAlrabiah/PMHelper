//
//  SegueToTasksTableView.swift
//  PMHelper
//
//  Created by aziz on 09/12/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit

class SegueToTasksTableView: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender.tag == 4 {
            let nextVc = self.storyboard!.instantiateViewController(withIdentifier: "Views2") as! EverythingTableView
            self.navigationController?.pushViewController(nextVc, animated: true)
            return
        }
        
        let nextVc = self.storyboard!.instantiateViewController(withIdentifier: "Views") as! TasksTableView
        nextVc.kindOfView = sender.tag
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
}
