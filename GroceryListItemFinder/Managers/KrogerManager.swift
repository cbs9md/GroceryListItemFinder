//
//  KrogerManager.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 6/24/23.
//

import Foundation

class KrogerManager {
    var page = 0
    let pageSize = 10
    let cvilleLocationId = "02900359"
    func getProducts(token: String, searchText: String, completion: @escaping ([Product]) -> ()) {
        let urlString = "https://api.kroger.com/v1/products"

        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
                
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "filter.locationId", value: cvilleLocationId),
            URLQueryItem(name: "filter.term", value: searchText),
            URLQueryItem(name: "filter.start", value: String(page * pageSize)),
            URLQueryItem(name: "filter.limit", value: String(pageSize))
        ]
            
        guard let finalURL = components?.url else {
            print("Failed to create final URL")
            return
        }
            
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token.trimmingCharacters(in: .whitespacesAndNewlines))", forHTTPHeaderField: "Authorization")
        
        NetworkHelper.performDataTask(request: request) { data in
            print("data: \(data.prettyPrintedJSONString)")
            let decoded = try! KrogerDecoder.decodeProducts(data)
            self.page += 1
            completion(decoded)
        }
    }
    
    func get22901(token: String) {
        let urlString = "https://api.kroger.com/v1/locations"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
            

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "filter.locationId", value: cvilleLocationId),
        ]

        
        guard let finalURL = components?.url else {
            print("Failed to create final URL")
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token.trimmingCharacters(in: .whitespacesAndNewlines))", forHTTPHeaderField: "Authorization")
        
        NetworkHelper.performDataTask(request: request) { data in
            print(data.prettyPrintedJSONString)
        }
    }
    
    func getCharlottesville() {
        let locationId = ""
    }
}
