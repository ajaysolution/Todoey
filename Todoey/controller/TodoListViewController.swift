//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Ajay Vandra on 1/27/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    var TodoItems : Results<Item>?
   
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    
       
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "delete") { (UIContextualAction,UIView, sucess:(Bool) -> Void) in
            sucess(true)
        }
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let add = UIContextualAction(style: .normal, title: "add") { (UIContextualAction, UIView, sucess:(Bool) -> Void) in
            sucess(true)
        }
        add.backgroundColor = .lightGray
        return UISwipeActionsConfiguration(actions: [add])
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = TodoItems?[indexPath.row]{
            cell.accessoryType = item.done ? .checkmark : .none
            
            cell.textLabel?.text = item.title
        }else{
            cell.textLabel?.text = "no item added"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let item = TodoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                    //realm.delete(item)
                }
            }
            catch{
                print(error)
            }
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currenCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        currenCategory.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }


    func loadItems(){

        TodoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
     
        tableView.reloadData()
    }
//}
//extension TodoListViewController : UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//      loadItems(with: request)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
}
