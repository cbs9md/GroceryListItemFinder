//
//  RouteView.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 6/27/23.
//

import SwiftUI

struct RouteView: View {
    @ObservedObject var vm: ContentViewModel
    var body: some View {
        VStack {
            
        }
        .onAppear {
            vm.mapRoute()
        }
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView(vm: .init())
    }
}
