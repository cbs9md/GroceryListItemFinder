//
//  SearchProductsView.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 6/24/23.
//

import SwiftUI

struct SearchProductsView: View {
    @ObservedObject var vm: ContentViewModel
    var body: some View {
        VStack {
            SearchBarView(text: $vm.searchText) { text in
                if text == "" {
                    vm.products = []
                } else {
                    vm.searchProducts(text: text)
                }
            }
            .background(Color.gray.opacity(0.15))
            .cornerRadius(14)
            .padding()
            List {
                ForEach(vm.products) { product in
                    HStack {
                        if let url = product.imageUrl {
                            ImageLoaderView(url: url)
                        }
                        Button(product.name) {
                            vm.addProduct(product)
                        }
                    }
                    .onAppear {
                        if product == vm.products.last {
                            vm.searchProducts(text: vm.searchText)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .onDisappear {
                vm.products = []
            }
        }
    }
}

struct SearchProductsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProductsView(vm: .init())
    }
}
