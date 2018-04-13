//
//  ToDoListViewControllerTableViewController.swift
//  ToDoList_Realm
//
//  Created by Theodore Schrey on 4/10/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //    var listArray = [String]()  //array to hold cell data (ToDos)
    var itemArray = [Item]()       //change to have custom item so we can associate properties with it, in this case, the checkmark.  since we reuse cells, it appears in the reused cell if in top cell, so we want to be able to associate it with the data, not the cell.
    
    
    //Property observer didSet triggers only if the value of selectedCategory was set. Since this property is called from CategoryVC's prepare for segue, it happens first.  So, we put loadItems here instead of viewDidLoad which ensure that it only loads if selectedCategory received an update.
    var selectedCategory : Category? {//optional because initially, until a category in CategoryVC is used, this is nil.
        didSet {
            loadItems()
        }
    }
    
    //1. To use COREDATA to store data, we reference a context in AppDelegate to add/save/load an Item
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    override func viewDidLoad() {
        super.viewDidLoad()
        //since using TableViewController, no need to set self as delegate for TableViewDelegate and TableViewDataSource
        
        //        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        loadItems()   //moved to didSet observer.
    }
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    
    
    
    
    //MARK: - TableView DataSource Methods:  two required.  cellForRowAt and numberOfRowsInSection
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Here, we cast to the CustomMessageCell type because using the custom cell....since default prototype, no cast as in Chat.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //check hidden/shown depending on state of .done property
        if item.done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }//end cellForRowAt
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK: - TableView Delegate Methods:
    //this functon detects which row/cell user selects
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)    //this makes highlight go away after clicking on cell
        
        //Toggle .done in Item (checkmark)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
    }//end didSelectRowAt
    
    
    //MARK: - ADD NEW ITEM TO LIST
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        addNewItem()
    }
    
    func addNewItem (){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type in New Item Here"
            textField = alertTextField
        }//end addTextField
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let userInput = textField.text {
                //                var newItem = Item()          //replaced below with Item(<#T##NSManagedObjectContext#>)
                
                let newItem = Item(context: self.context)
                newItem.title = userInput   //have to set all Attributes since no default values when using CoreData
                newItem.done = false
                newItem.withParentCategory = self.selectedCategory  //associates the item with the category selected to get here.  .withParentCategory is the RELATIONSHIP establisehd in CoreData file.
                
                self.itemArray.append(newItem)
                self.tableView.reloadData()
                self.saveItems()
                
            }else {
                print ("nothing entered")
            }//end if-else
            
        }//end action
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }//end addNewItem
    
    
    //MARK: - SearchBar Delegate Methods:
    
    
    
    //MARK: - SAVE data via CoreData
    func saveItems(){
        
        do{
            try context.save()
        }catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }//end save data
    
    
    
    //MARK: - LOAD data saved via CoreData
    func loadItems(){
        
        let request: NSFetchRequest <Item> = Item.fetchRequest()
        
        //      this part is to sort through data and only load items in selectedCategory
        if let category = selectedCategory {
            let loadPredicate = NSPredicate(format: "withParentCategory.name MATCHES %@", category.name!)
            request.predicate = loadPredicate
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }//end optional binding
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print ("Error loading context: \(error)")
        }
        
        
        tableView.reloadData()
    }//end load data
    
    
    
}//end class





//THIS WAS MOVED TO OWN FILE

//MARK: Search Bar Extension
//extension ToDoListViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()     //<= same as when Loading Data
//
//        //in order to QUERY and set FILTERS, must use NSPredicate:
//        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)     //[cd] deactivates caps and diacritics
//        request.predicate = predicate
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)     //sets to sort in ascending order
//        request.sortDescriptors = [sortDescriptor]
//        //the avove two sets can be shortened:  (ex)request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        do{
//            listArray = try context.fetch(request)
//        }catch{
//            print ("Error loading context: \(error)")
//        }
//
//        tableView.reloadData()

///*Angela shortens the above by adding a parameter to the Load and calling it.  Also needs a defualt parameter (Item.FetchRequest) so that the call in ViewDidLoad can still work.
//
//         eg: func loadItems(with request: NSFetchRequest<Item> = Item.FetchRequest){}
//
//        When written like this, the 'with' is external (what is seen when calling the method) and the 'request' is internal--used in the method.  So, if a parm is provided, it is used.  If not and just called by loadItems(), will use default value.
//*/
//    }//end searchBarSearchButtonClicked
//
//    //MARK: Make List Revert to ALL items
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.count == 0 {
//            loadItems()
//
//            //to make the keyboard disappear, make it not 1st Responder need to first put in Main thread
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//
//    }
//
//
//}//end UISearchBarDelegate Extension

