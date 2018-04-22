//
//  ToDoListViewControllerTableViewController.swift
//  ToDoList_Realm
//
//  Created by Theodore Schrey on 4/10/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    //Realm data holding container of type Results
    var toDoItems : Results<Item>?
    
    //1. instantiate Realm object
    let realm = try! Realm()
    
    
    //Property observer didSet triggers only if the value of selectedCategory was set. Since this property is called from CategoryVC's prepare for segue, it happens first.  So, we put loadItems here instead of viewDidLoad which ensure that it only loads if selectedCategory received an update.
    var selectedCategory : Category? {//optional because initially, until a category in CategoryVC is used, this is nil.
        didSet {
            loadItems()
        }
    }
    
   
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    override func viewDidLoad() {
        super.viewDidLoad()
        //since using TableViewController, no need to set self as delegate for TableViewDelegate and TableViewDataSource
        
//                print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        loadItems()   //moved to didSet observer.
    }
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    
    
    
    
    //MARK: - TableView DataSource Methods:  two required.  cellForRowAt and numberOfRowsInSection
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Here, we cast to the CustomMessageCell type because using the custom cell....since default prototype, no cast as in Chat.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if item.done == true {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
//        let item = toDoItems?[indexPath.row]
//
//        cell.textLabel?.text = item?.title ?? "There are no items yet"
//
//        //check hidden/shown depending on state of .done property
//        if (item?.done) == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }//end cellForRowAt
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    //MARK: - TableView Delegate Methods:
    //this functon detects which row/cell user selects
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)    //this makes highlight go away after clicking on cell
        
        //Toggle .done in Item (checkmark).  When updating Realm data, must be within write{}
        if let item = toDoItems {
            do {
                try realm.write {
                    item[indexPath.row].done = !item[indexPath.row].done
                    
                    //instead of toggle, DELETE:
//                    realm.delete(item[indexPath.row])
                }
            } catch {
                print ("Error saving done status, \(error)")
            }
        }
        //        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done    //see above..Realm needs write{}
//        saveItems()
        
        tableView.reloadData()  //since no longer using save()
        
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
//            if let userInput = textField.text {
//                let newItem = Item()
//                newItem.title = userInput
            
                //for realm, also need to specify that the category isn't nil
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            
                            //angela's challenge, sort by date created, so adding this
                            newItem.dateCreated = NSDate()
                    
                            //in order to update the items LIST<> in the current Category, need to append it.  However, this can not be modified outside of a write (save) transaction, so have to move SAVE code here.
                            currentCategory.items.append(newItem)

                            self.tableView.reloadData()
                        }
                    }catch {
                        print("Error saving item: \(error)")
                    }
                    
                }
                
            
                
//            }else {
//                print ("nothing entered")
//            }//end if-else
            
        }//end action
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }//end addNewItem
    
    
    //MARK: - SearchBar Delegate Methods:
    
    
    
    //MARK: - SAVE  !!!See comments in AddNewItem() moved .write function there
//    func saveItems(item : Item){
//        do{
//            try realm.write {
//                realm.add(item)
//        }
//    }catch {
//    print("Error saving item: \(error)")
//    }
//
//        tableView.reloadData()
//    }//end save data
    
    
    
    //MARK: - LOAD data saved via CoreData
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending : true)

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

