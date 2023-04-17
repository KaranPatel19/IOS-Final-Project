//
//  APIService.swift
//  ToDoList
//
//  Created by Vishal Sutar on 2023-04-17.
//

import Foundation

enum APIServiceErrors: Error{
    case APIFailed;
}

class APIService{
    
    public static func fetchData(from url_string: String) async throws -> Data{
        guard
            let url = URL(string: url_string)
        else{
            throw APIServiceErrors.APIFailed
        }
        let(data,_) = try await URLSession.shared.data(from: url)
        return data
    }
    
}
