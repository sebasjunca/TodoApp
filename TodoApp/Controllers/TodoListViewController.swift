//
//  ViewController.swift
//  TodoApp
//
//  Created by Sebastián Junca on 1/14/19.
//  Copyright © 2019 Zenze. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let itemArrayKey = "ToDoListArray"

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
   
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) //Shows where is data stored for our app

        // searchBar.delegate = self
        
        // This is used to show the data stored into the user defaults plist database

    }

    // MARK - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //changes the Bool to the opposite stored.
        
        // To delete items
        //  context.delete(itemArray[indexPath.row])
        //  itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
    
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            // What will happen once the user clicks the Add Item button on UIAlert
            
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory // links the parentCategory relation in coreData to the selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
           
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

            
        }
        
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
        
    
    }
    //MARK - Model manipulation methods
    
    func saveItems() {
      
      //  let encoder = PropertyListEncoder()
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Load items from the core data database
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
       
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try  context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

// The extension helps you to orginize better your code

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query
        let request: NSFetchRequest<Item> = Item.fetchRequest()
     
        // for all the items in the Array search for the title that CONTAINS %@ this text, check NSPredicate Cheat sheet
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate) // triggers loadItems func with the parameter of let request
        
    }
    
    // This triggers the delegate method when the text inside the searchbar has changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async { // helps to manage background tasks and optimize experience
                searchBar.resignFirstResponder() // Dismisses the keyboard
            }
            
            
        }
    }
    
}
