//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Sebastian Junca on 08/02/2019.
//  Copyright © 2019 Zenze. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let categoryArrayKey = "ToDoListCategoryArray"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()

    }

    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name

        return cell
    }
  
    
    // MARK: - Data manipulation methods
    
    func saveCategory() {
        
        //  let encoder = PropertyListEncoder()
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try  context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Category", style: .default) {(action) in
            // What will happen once the user clicks the Add Item button on UIAlert
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        }
 
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
   
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    
}

extension CategoryViewController: UISearchBarDelegate {
    
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        // for all the categories in the Array search for the title that CONTAINS %@ this text, check NSPredicate Cheat sheet
        
        request.predicate = NSPredicate(format: "name CONTAINS %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        
        
        loadCategories(with: request) // triggers loadCategories func with the parameter of let request
        
    }
    
    // This triggers the delegate method when the text inside the searchbar has changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadCategories()
            
            DispatchQueue.main.async { // helps to manage background tasks and optimize experience
                searchBar.resignFirstResponder() // Dismisses the keyboard
            }
            
            
        }
    }
    
}
