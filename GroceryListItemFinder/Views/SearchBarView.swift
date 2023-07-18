//
//  SearchBarView.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 6/25/23.
//

import SwiftUI

struct SearchBarView: View {
        
    @Binding var text: String
    var search: (String) -> ()
    
    @State var isEditing = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search...", text: $text)
                {toggleIsEditing($0)}
                onCommit: {
                    search(text)
                }
                    .focused($isFocused)
                    .foregroundColor(.gray)
                Spacer()
                if isEditing {
                    Button(action: clearText) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(10)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
    }
    
    func toggleIsEditing(_ isEditing: Bool) {
        withAnimation(.easeInOut(duration: 0.15)) {
            self.isEditing = isEditing
        }
    }
    
    func clearText() {
        text.removeAll()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""), search: { _ in })
    }
}
