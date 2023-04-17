//
//  APIViewController.swift
//  ToDoList
//
//  Created by Karan Patel on 2023-04-16.
//

import UIKit

class APIViewController: UIViewController {
    
    @IBOutlet weak var apiButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func apiButtonTapped(_ sender: UIButton) {
        let url = "https://www.boredapi.com/api/activity/"
        Task{
            let data: Data = try await APIService.fetchData(from: url)
            do{
              //  let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let decoder = JSONDecoder()
                let todoData = try decoder.decode(APIModel.self, from: data )
                
                print(todoData)
                Output(api: "Test", json: todoData)
            }catch{
                print(error)
            }
        }
        
    }
    @IBOutlet weak var labelTodoItem: UILabel!
    private func Output(api name: String, json: APIModel){
      
        labelTodoItem.text = "\(json.activity)"
       
    }
}
