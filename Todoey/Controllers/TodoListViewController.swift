//
//  ViewController.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/3/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var iteamArray = [TodoItem]()
    var selectedCategory: Category? {
        didSet{
            loadDate()
        }
    }
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: TableView DataSource Method

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = iteamArray[indexPath.row]
        
        cell.textLabel?.text = item.tittle
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iteamArray.count
    }

    
    //MARK: TableView Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        iteamArray[indexPath.row].done = !iteamArray[indexPath.row].done
        
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != nil{
                
                let item = TodoItem(context: self.context)
                item.tittle = textField.text!
                item.done = false
                item.parentCategory = self.selectedCategory
                self.iteamArray.append(item)
                self.saveData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do{
            try context.save()
        }catch{
            print("Error is \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadDate(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            iteamArray = try context.fetch(request)
        }catch{
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let predicate = NSPredicate(format: "tittle CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "tittle", ascending: true)]
        print("test")
        loadDate(with: request, predicate: predicate)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadDate()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
