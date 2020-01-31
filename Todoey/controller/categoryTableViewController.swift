//
//  categoryTableViewController.swift
//  Todoey
//
//  Created by Ajay Vandra on 1/30/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import RealmSwift


class categoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    var cat : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
     
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no category added"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "sec", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let vc = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            vc.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
               
               let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                   
                let newItem = Category()
                   newItem.name = textField.text!
//                   newItem.done = false
                   
                self.save(category: newItem)
               }
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Create New Item"
                   textField = alertTextField
               }
               
               alert.addAction(action)
               
               present(alert, animated: true, completion: nil)
    }
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    func loadItems(){

        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
}
