//
//  AuthenticationManager.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 5/25/23.
//

import Foundation

class AuthenicationManager {
    
    func getToken(completion: @escaping (String) -> ()) {
        let urlString = "https://api.kroger.com/v1/connect/oauth2/token"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let credentials = "\(clientId):\(clientSecret)"
        
        guard let credentialsData = credentials.data(using: .utf8) else {
            print("Failed to encode credentials")
            return
        }
        
        let base64Credentials = credentialsData.base64EncodedString()
        let grantType = "client_credentials"
        let scope = "product.compact"
        let parameters = "grant_type=\(grantType)&scope=\(scope)"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData
        
        NetworkHelper.performDataTask(request: request) { data in
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let token = json["access_token"] as? String {
                    print("Response data string:\n \(json)")
                    print("token is: \(token)")
                    completion(token)
                }
            } else {
                print("Could not parse string.")
            }
        }
    }
}
