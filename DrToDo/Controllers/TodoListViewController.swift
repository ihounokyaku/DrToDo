//
//  ViewController.swift
//  DrToDo
//
//  Created by Dylan Southard on 2018/04/08.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [ToDoItem]()
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = self.itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        self.saveItems()
    }

    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                
                let item = ToDoItem(context: self.context)
                item.name = textField.text!
                item.parentCategory = self.selectedCategory
                self.itemArray.append(item)
                self.saveItems()
                self.tableView.reloadData()
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "new todo"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print(error)
        }
        
    }
    
    func loadItems(with request:NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate:NSPredicate? = nil) {
        do {
            
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
            print("category name is \(self.selectedCategory!.name!)")
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            } else {
                request.predicate = categoryPredicate
            }
            self.itemArray = try self.context.fetch(request)
            self.tableView.reloadData()
            
        } catch {
            print(error)
        }
    }
    
}

//MARK: - SearchBar methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.loadItems(with: request, predicate: NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0  {
            self.loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

