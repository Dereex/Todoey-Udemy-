//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/7/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDate()
    }


    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destenationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destenationVC.selectedCategory = categoryArray[indexPath.row]
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
                let category = Category(context: self.context)
                category.name = textField.text!
                self.categoryArray.append(category)
                self.saveDate()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveDate() {
        do{
            try context.save()
        }catch{
            print("Save error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadDate(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("load error: \(error)")
        }
        tableView.reloadData()
    }
    
    
}
