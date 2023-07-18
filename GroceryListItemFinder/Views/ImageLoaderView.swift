//
//  ImageLoaderView.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 7/17/23.
//

import SwiftUI

struct ImageLoaderView: View {
    let url: String
    @State var image: Image? = nil
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            guard let url = URL(string: url) else { return }

            let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        if let uiImage = UIImage(data: data) {
                            self.image = Image(uiImage: uiImage)

                        }
                    }
                }
            }

            dataTask.resume()
        }
    }
}

struct ImageLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderView(url: "")
    }
}
