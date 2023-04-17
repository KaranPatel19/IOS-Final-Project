//
//  ViewController.swift
//  ToDoList
//
//  Created by Karan Patel on 2023-04-15.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoListItem]()
    let tableview:UITableView = {
        let table  = UITableView()
       
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    override func viewDidLoad() {
            super.viewDidLoad()
            getAllItems()
            title = "Todo List"
            view.addSubview(tableview)
            tableview.delegate = self
            tableview.dataSource = self
            tableview.frame = view.bounds
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddTap))
        }
        @objc private func AddTap(){
            let alert = UIAlertController(title: "New Item",
                                          message: "Add todo",preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                    return
                }
                self?.createItem(name: text)
            }))
            present(alert, animated: true)
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return models.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let model = models[indexPath.row]
            cell.textLabel?.text = model.name
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let item = models[indexPath.row]
            let sheet = UIAlertController(title: "Edit",
                                          message: nil ,preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                let alert = UIAlertController(title: "Edit todo",
                                              message: "Edit your task",preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                alert.textFields?.first?.text = item.name
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
                        return
                    }
                    self?.updateItem(item: item, newName: newName)
                }))
                self.present(alert, animated: true)
            }))
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self ]_ in
                self?.deleteItem(item: item)
            }))
            present(sheet, animated: true)
        }
        
         func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    //CoreData
    func getAllItems(){
    do{
        models = try context.fetch(ToDoListItem.fetchRequest())
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
      }
        catch{
            
        }
    }
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        do{
            try context.save()
            getAllItems()

        }
        catch{
            
        }
    }
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
}

