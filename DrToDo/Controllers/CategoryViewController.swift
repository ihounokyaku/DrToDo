//
//  CategoryViewController.swift
//  DrToDo
//
//  Created by Dylan Southard on 2018/04/10.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    var categories: Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.load()
        self.tableView.rowHeight = 80.0
        
    }

    
    //MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = self.categories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categories = self.categories {
            if categories.count > 0 {
                self.performSegue(withIdentifier: "goToItems", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data manipulation methods
    func save(category:Category) {
        do {
            try self.realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func load() {

        self.categories = realm.objects(Category.self)
        
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let category  = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("error deleting \(error)")
            }
        }
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
                let category = Category()
                category.name = newField.text!
                self.save(category:category)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

