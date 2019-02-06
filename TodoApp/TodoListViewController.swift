//
//  ViewController.swift
//  TodoApp
//
//  Created by Kathleen Acosta on 1/14/19.
//  Copyright © 2019 Zenze. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy eggs", "Destroy Demogorgon", "Try new Swift 5"]
    
    let defaults = UserDefaults.standard // interface to the users defaults database where you store key value pairs persistently used across launches of your app.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // This is used to show the data stored into the user defaults plist database
        if let itemArray = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    
    }

    // MARK - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
    
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            // What will happen once the user clicks the Add Item button on UIAlert
            
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray") // Stores the item added to the user default database to make it persistent.
            
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
