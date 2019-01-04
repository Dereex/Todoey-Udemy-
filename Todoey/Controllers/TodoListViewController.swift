//
//  ViewController.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/3/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var iteamArray = [TodoItem]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [TodoItem] {
            iteamArray = items
        }
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
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != nil{
                let item = TodoItem()
                item.tittle = textField.text!
                self.iteamArray.append(item)
                self.defaults.set(self.iteamArray, forKey: "TodoListArray")
                self.tableView.reloadData()
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

