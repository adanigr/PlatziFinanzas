//
//  TransactionActions.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/23/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

class TransactionActions {
    
    func completeAction(at indexPath: IndexPath, viewController :UIViewController) -> UIContextualAction {
        // 
        // configure action
        let action = UIContextualAction(style: .normal, title: "Complete") { (action, view, completionHandler) in
            
            //self.viewModel.remove(at: indexPath)
            //self.tableView?.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            //do stuff
            completionHandler(true)
            //            let data:NSDictionary = self.conversations[indexPath.row] as! NSDictionary
            //            print(data)
            let alert:UIAlertController = UIAlertController(title: "", message: "are you sure want to delete ?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: { (action) in
            }))
            // Write self in direct view controller
            //self.present(alert, animated: true, completion: nil)
            viewController.present(alert, animated: true, completion: nil)
        }
        
        action.image = UIImage(named: "Trash")
        //action.backgroundColor = .green
        action.backgroundColor = UIColor(red: 0/255, green: 148/255, blue: 204/255, alpha: 1.0)
        
        return action
    }
}
