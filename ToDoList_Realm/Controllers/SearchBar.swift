//
//  SearchBar.swift
//  ToDoList_Realm
//
//  Created by Theodore Schrey on 4/10/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//
/*
import UIKit
import CoreData


extension ToDoListViewController: UISearchBarDelegate{
    
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()     //<= same as when Loading Data
//
//        //in order to QUERY and set FILTERS, must use NSPredicate:          //%@ means value of searchBar.text goes here.
//        //        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)     //[cd] deactivates caps and diacritics
//        let predicate = NSPredicate(format: "(withParentCategory.name MATCHES %@) AND (title CONTAINS [cd] %@)", (selectedCategory?.name)!, searchBar.text!)
//        request.predicate = predicate
//        //NOTE:  Angela uses NSCompound Predicate (SECTION 19, LECTURE 260)
//
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)     //sets to sort in ascending order
//        request.sortDescriptors = [sortDescriptor]
//        //the avove two sets can be shortened:  (ex)request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print ("Error loading context: \(error)")
//        }
//
//        tableView.reloadData()
//        /*Angela shortens the above by adding a parameter to the Load and calling it.  Also needs a defualt parameter (Item.FetchRequest) so that the call in ViewDidLoad can still work.
//
//         eg: func loadItems(with request: NSFetchRequest<Item> = Item.FetchRequest){}
//
//         When written like this, the 'with' is external (what is seen when calling the method) and the 'request' is internal--used in the method.  So, if a parm is provided, it is used.  If not and just called by loadItems(), will use default value.
//         */
//    }//end searchBarSearchButtonClicked
//
    
    
    //MARK: Make List Revert to ALL items
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
//            loadItems()
            
            //to make the keyboard disappear, make it not 1st Responder need to first put in Main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else { //This a suggestion from student.  Makes search update each time a new letter is typed.
            //            searchBarSearchButtonClicked(searchBar)
        }
        
    }
    
    
}//end UISearchBarDelegate Extension  */
