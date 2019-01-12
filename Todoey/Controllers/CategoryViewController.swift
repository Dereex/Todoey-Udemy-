//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/7/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDate()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArray?[indexPath.row]{
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destenationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destenationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - TableView Manipulation Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add category", style: .default) { (alert) in
            if textField.text != nil {
                let category = Category()
                category.name = textField.text!
                category.color = UIColor.randomFlat.hexValue()
                self.save(category: category)
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Save error: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadDate() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //MARK: - Delete date from swipre
    
    override func updateModel(at indexPath: IndexPath) {
        do{
            try self.realm.write {
                self.realm.delete(self.categoryArray![indexPath.row])
            }
        }catch{
            print("Delete Error: \(error)")
        }
    }
}
