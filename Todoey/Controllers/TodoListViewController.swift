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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoList.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDate()
        
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
                
                let item = TodoItem()
                item.tittle = textField.text!
                
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(iteamArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error is \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadDate() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                iteamArray = try decoder.decode([TodoItem].self, from: data)
            }catch{
                print(error)
            }
        }
    }
    
}

