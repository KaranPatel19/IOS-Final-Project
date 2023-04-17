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

