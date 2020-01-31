//
//  categoryTableViewController.swift
//  Todoey
//
//  Created by Ajay Vandra on 1/30/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import CoreData


class categoryTableViewController: UITableViewController {
    var categories = [Category]()
    
    var cat : String = ""

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
     
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "sec", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let vc = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            vc.selectedCategory = categories[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
               
               let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                   
                let newItem = Category(context: self.context)
                   newItem.name = textField.text!
//                   newItem.done = false
                   
                self.categories.append(newItem)
                   
                  
                self.saveItems()
               }
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Create New Item"
                   textField = alertTextField
               }
               
               alert.addAction(action)
               
               present(alert, animated: true, completion: nil)
    }
    func saveItems(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
}
