//
//  ContentView.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 5/25/23.
//

import SwiftUI

let clientId = ProcessInfo.processInfo.environment["clientId"]!
let clientSecret = ProcessInfo.processInfo.environment["clientSecret"]!

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.items) { item in
                    Text(item.name)
                }
            }
            .listStyle(.plain)
            .overlay(alignment: .bottomTrailing, content: {
                NavigationLink(destination: EmptyView()) {
                    Text("Map Route")
                        .foregroundColor(.primary)
                        .bold()
                        .padding()
                        .background(Color.green)
                        .cornerRadius(4)
                }
            })
            .navigationTitle("Grocery List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Charlottesville, VA") {
                        print("Pressed")
                        vm.get22901()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Item") {
                        vm.showProductSearch()
                    }
                }
            }
            .sheet(isPresented: $vm.showingProductSearch) {
                SearchProductsView(vm: vm)
            }
        }
        .padding()
    }
}

class ContentViewModel: ObservableObject {
    let auth = AuthenicationManager()
    let manager = KrogerManager()
    @Published var products = [Product]()
    @Published var items = [ListItem]()
    @Published var showingProductSearch = false
    @Published var searchText = ""
    func showProductSearch() {
        showingProductSearch = true
    }
    func hideProductSearch() {
        showingProductSearch = false
    }
    
    func searchProducts(text: String) {
        auth.getToken { [weak self] token in
            self?.manager.getProducts(token: token, searchText: text) { products in
                DispatchQueue.main.async {
                    self?.products += products
                }
            }
        }
    }
    
    func addProduct(_ product: Product) {
        items.append(ListItem(name: product.name, product: product))
        withAnimation {
            showingProductSearch = false
        }
    }
    
    func get22901() {
        auth.getToken { [weak self] token in
            self?.manager.get22901(token: token)
        }
    }
    
    func mapRoute() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class KrogerDecoder {
    static func decodeProducts(_ data: Data) throws -> [Product] {
        let krogerData = try JSONDecoder().decode(KrogerData.self, from: data)
        
        let products = krogerData.data.map { datum in
            let name = datum.description
            let imageUrl = datum.images
                .first(where: { $0.perspective == .front})?.sizes
                .first(where: { $0.size == .thumbnail })?.url
            return Product(name: name, imageUrl: imageUrl)
        }

        return products
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

struct Product: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageUrl: String?
}

struct ListItem: Identifiable {
    let id = UUID()
    let name: String
    let product: Product
}
