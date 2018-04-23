//
//  SwipeExtension.swift
//  ToDoList_Realm
//
//  Created by Theodore Schrey on 4/22/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

extension CategoryViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
//            print ("Swipe delete successful")
            
            if let categoryToDelete = self.categories?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categoryToDelete)
                    }
                }catch {
                    print("Error deleting Category: \(error)")
                }
                
//                tableView.reloadData()    //oncd added editActionsOptionsForRowAt() below, this not needed becuase it is called by this method to edit the ActionsOptions!
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete_icon")
        
        return [deleteAction]
    }
    
    //as an optional method, this allows customization of the behavior of the swipe actions.  This will just use the .destructive option to get rid when swiped all the way or delete selected.
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive

        
        return options
    }
    
    
}//end extension
