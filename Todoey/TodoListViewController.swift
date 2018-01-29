//
//  ViewController.swift
//  Todoey
//
//  Created by Olar's Mac on 1/29/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Kill Maveric", "Buy egg", "Shoot Ibk"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK - Tableview Datasource Methoda
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        }
        
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        // remove the grey hilight on selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New"
            textField = alertTextField
            ////print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
}

