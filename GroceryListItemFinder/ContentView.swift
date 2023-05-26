//
//  ContentView.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 5/25/23.
//

import SwiftUI

let clientId = "grocerylistitemfinder-bd4811879d07c02bab3de24b84f015215331275673206770950"
let clientSecret = "oyWPrR_wxj7ovZcMsKlkCqp1iyg0sKl2FqdnRl7R"

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.products) { product in
                    Text(product.name)
                }
            }
            .navigationTitle("Grocery List")
        }
        .padding()
        .onAppear {
            vm.getData()
        }
    }
}

class ContentViewModel: ObservableObject {
    let auth = AuthenicationManager()
    @Published var products = [Product]()
    func getData() {
        auth.getToken { token in
            getProducts(token: token) { products in
                DispatchQueue.main.async {
                    self.products = products
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getProducts(token: String, completion: @escaping ([Product]) -> ()) {
    let urlString = "https://api.kroger.com/v1/products?filter.term=fat%20free%20milk"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
        
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(token.trimmingCharacters(in: .whitespacesAndNewlines))", forHTTPHeaderField: "Authorization")
    
    NetworkHelper.performDataTask(request: request) { data in
        let decoded = try! KrogerDecoder.decodeProducts(data)
        completion(decoded)
    }
}

class KrogerDecoder {
    static func decodeProducts(_ data: Data) throws -> [Product] {
        var result = [Product]()
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
            if let array = json["data"] as? [[String: Any]] {
                let descriptions = array.compactMap { $0["description"] as? String }
                result = descriptions.map { Product(name: $0) }
            }
        } else {
            print("Failed to parse response")
        }
        return result
    }
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
}
