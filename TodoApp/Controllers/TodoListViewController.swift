//
//  ViewController.swift
//  TodoApp
//
//  Created by Sebastián Junca on 1/14/19.
//  Copyright © 2019 Zenze. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard // interface to the users defaults database where you store key value pairs persistently used across launches of your app.
    
    let itemArrayKey = "ToDoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        // This is used to show the data stored into the user defaults plist database
        if let items = defaults.array(forKey: itemArrayKey ) as? [Item] {
           itemArray = items
        //}
        
        // Do any additional setup after loading the view, typically from a nib.
    
    }

    // MARK - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       
        // This could be expressed simpler :
        
            /*
            if item.done == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            */
        
        // Like this (ternary operator) :
        
        // value = condition ? valueIfTrue : valueIfFalse
        // ? checks if it's true or false

        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //changes the Bool to the opposite stored.

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
    
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            // What will happen once the user clicks the Add Item button on UIAlert
            
           
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: self.itemArrayKey ) // Stores the item added to the user default database to make it persistent.
            
            self.tableView.reloadData()
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

            
        }
        
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
        
    
    }
    
}
