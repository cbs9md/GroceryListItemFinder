//
//  NetworkHelper.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 5/25/23.
//

import Foundation

class NetworkHelper {
    static func performDataTask(request: URLRequest, completion: @escaping (Data) -> ()) {        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            completion(data)
        }
        
        task.resume()
    }
}
