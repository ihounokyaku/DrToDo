//
//  CategoryViewController.swift
//  DrToDo
//
//  Created by Dylan Southard on 2018/04/10.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.load()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    //MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.categories[indexPath.row].name
        return cell
    }
    
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Data manipulation methods
    func save() {
        do {
            try self.context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func load(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
           self.categories = try self.context.fetch(request)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var newField:UITextField!
        let alert = UIAlertController(title: "Add New Category", message: "This is a category", preferredStyle: .alert)
        alert.addTextField {
            (textField) in
            newField = textField
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if newField.text! != "" {
                let category = Category(context: self.context)
                category.name = newField.text!
                self.categories.append(category)
                self.save()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
