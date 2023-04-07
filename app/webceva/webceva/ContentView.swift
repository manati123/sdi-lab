//
//  ContentView.swift
//  webceva
//
//  Created by Silviu Preoteasa on 07.04.2023.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var items: [API.Item] = []
    
    func getItems() {
        API.instance.getItems() { [weak self] items in
            self?.items = items
            
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        LazyVStack {
            Button {
                viewModel.getItems()
            }label: {
                Text("Get Items From API")
            }
            ForEach(viewModel.items, id:\.self) { item in
                Text(item.name)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
