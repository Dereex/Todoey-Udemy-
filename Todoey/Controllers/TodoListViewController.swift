//
//  ViewController.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/3/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{

    var todoItems: Results<TodoItem>?
    var selectedCategory: Category? {
        didSet{
            loadDate()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color{
        title = selectedCategory!.name
            updateNavBar(wuthHexCode: colorHex)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(wuthHexCode: "1E4D8F")
    }
    
    //MARK: - NavBar update method
    
    func updateNavBar(wuthHexCode colorHexCode: String){
        guard let navBar =  navigationController?.navigationBar else {fatalError("NavBarNil")}
        
        if let navBarColor = UIColor(hexString: colorHexCode) {
            navBar.barTintColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            searchBar.barTintColor = navBarColor
        }
    }
    
    
    //MARK: TableView DataSource Method

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: (selectedCategory?.color)!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todoItems?.count)!)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    //MARK: TableView Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                        item.done = !item.done
                    }
            }catch{
                print("Done error: \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != nil{
                
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let item = TodoItem()
                            item.title = textField.text!
                            item.dateCreated = Date()
                            currentCategory.items.append(item)
                        }
                    }catch{
                        print("saveDate error: \(error)")
                    }
                }
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
    
    func loadDate() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    //MARK: - Delete date from swipre
    
    override func updateModel(at indexPath: IndexPath) {
        do{
            try self.realm.write {
                self.realm.delete(self.todoItems![indexPath.row])
            }
        }catch{
            print("Delete Error: \(error)")
        }
    }
    
}

//MARK: - Search Bar delegate method

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

