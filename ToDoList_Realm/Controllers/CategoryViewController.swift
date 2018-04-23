//
//  CategoryViewController.swift
//  ToDoList_Realm
//
//  Created by Theodore Schrey on 4/10/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    //1. instantiate Realm object
    let realm = try! Realm()
    
    //MARK: - Class Properties
//    var categoryArray = [Category]()
    var categories : Results <Category>?
    
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let grocery = Category(context: self.context) ; let errands = Category(context: self.context); let misc = Category(context: self.context)
        //        grocery.name = "grocery"; errands.name = "errands"; misc.name = "misc"
        //        categoryArray.append(grocery); categoryArray.append(errands); categoryArray.append(misc)
        
        loadCategories()
    }
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let cats = categories {
//            return cats.count
//        } else {
//            return 1    //if no categories, tableView to have just one row
//        }
        
        //the above can be written as a Nil Coalescing Operator.  The nil-coalescing operator (a ?? b) unwraps an optional a if it contains a value, or returns a default value b if a is nil. The expression a is always of an optional type. The expression b must match the type that is stored inside a.:
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let category = categories?[indexPath.row]
        
        //for swipe, cell delegate is self
        cell.delegate = self
        
        //tweek cell to look better
        tableView.rowHeight = 80
        
        //using Nil Coalescing Operator:
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
        
        return cell
    }//en cellForRowAt
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if cell selected,go to Item VC
        performSegue(withIdentifier: "ToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)//make highlight disappear
        
    }//end didSelectRowAt
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }//end prepare for Segue
    
    
    
    //MARK: - @IBAction and results
    
    @IBAction func addCategoryButtonTapped(_ sender: UIBarButtonItem) {
        addNewCategory()
    }
    
    
    func addNewCategory(){
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }//end add textField
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let userInput = textField.text {
                let newCategory = Category()
                newCategory.name = userInput
                
                //where with other data storage, we had to append the array holding data, Realm uses Results<> container which auto-updates, so no need to append.
                self.tableView.reloadData()
                self.saveCategories(category: newCategory)
            }//end if
        }//end action
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }//end add new category
    
    
    
    
    //MARK: - save data to Realm
    func saveCategories(category: Category){
        //this is how you save data into Realm. 
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }//end save data
    
    //MARK: - load data saved from Realm
    func loadCategories(){

        categories = realm.objects(Category.self)
        
    }//end load data
    
    
    
}//end class



