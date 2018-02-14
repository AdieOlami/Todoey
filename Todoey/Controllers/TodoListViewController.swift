//
//  ViewController.swift
//  Todoey
//
//  Created by Olar's Mac on 1/29/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name

        
        guard let colorHex = selectedCategory?.color else { fatalError() }
            updateNavBar(withHexCode: colorHex)
        
            
        
        
        
    }
    //1297FF
    //9FD6FF
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1297FF")

    }
    
    //MARK: - navbar Color
    
    func updateNavBar(withHexCode colorHexCode : String) {
        // using guard let instead of if  let cuz of the lenght
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navbar does not exist")
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            searchBar.barTintColor = navBarColor
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        } else {
            // Fallback on earlier versions
        }
            navBar.barTintColor = navBarColor
        
    }

    
    //MARK: - Tableview Datasource Methoda
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
            //Tenery operation
            // value = condition ? valueifTrue : valueifFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No items"
            
        }
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
            try realm.write {
                //realm.delete(item)
                item.done = !item.done
                }
            } catch {
                print("error saving stat")
            }
        }
        tableView.reloadData()
    }
    
    //MARK - Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            if textField.text != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("error items")
                    }
                }
            self.tableView.reloadData()
//            self.saveItem()
              
            }
            else {
                print("empty list")
            }

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New"
            textField = alertTextField
            ////print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)


    }

    //MARK - Model manipulation
    
//    func saveItem() {
//
//        do {
//           try //context.save()
//        }
//        catch {
//            print(error)
//        }
//        self.tableView.reloadData()
//
//    }
    
    // method with internal , external paramater and default value
    // to avoid over writing our predicatess we include a predicate property in our function

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data

    override func updateModel(at indexPath: IndexPath) {
        //super.updateModel(at: indexPath)
        if let item = self.todoItems?[indexPath.row] {
            do {
                try! self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("error")
            }
            //tableView.reloadData()
        }
        
    }

 }
//}

//MARk: - Search
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    //loading respect to change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

