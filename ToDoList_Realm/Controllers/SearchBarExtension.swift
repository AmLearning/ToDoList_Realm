//
//  SearchBar.swift
//  ToDoList_Realm
//
//  Created by Theodore Schrey on 4/17/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//
import UIKit
import RealmSwift


extension ToDoListViewController: UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //in order to QUERY and set FILTERS, must use NSPredicate:          //%@ means value of searchBar.text goes here.
    
        let predicate = NSPredicate(format: "(title CONTAINS [cd] %@)", searchBar.text!)

//        toDoItems = toDoItems?.filter(predicate).sorted(byKeyPath: "title", ascending: true)
        toDoItems = toDoItems?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        
        //or, this is the format Angela used
//        toDoItems = toDoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
    //MARK: Make List Revert to ALL items
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            
            //to make the keyboard disappear, make it not 1st Responder need to first put in Main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else { //This a suggestion from student.  Makes search update each time a new letter is typed.
            searchBarSearchButtonClicked(searchBar)
        }
        
    }
    
    
}//end UISearchBarDelegate Extension

