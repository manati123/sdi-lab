//
//  AddView.swift
//  webceva
//
//  Created by Silviu Preoteasa on 08.04.2023.
//

import SwiftUI

struct AddView: View {
    @State var newItem: API.Item = .init(_id: "", name: "", description: "", price: -1, __v: -1)
    @State private var price: String = ""
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    let onAdd: (API.Item)->Void
    var body: some View {
        VStack {
            Text("Create View")
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    TextField("", text: $newItem.name)
                        .placeholder("Name: ", when: newItem.name.isEmpty)
                    TextField("", text: $newItem.description)
                        .placeholder("Description: ", when: newItem.description.isEmpty)
                    TextField("", text: $price)
                        .keyboardType(.numberPad)
                        .placeholder("Price: ", when: price.isEmpty)
                }.foregroundColor(.white)
                    .background(Color.green)
                    
                Spacer()
            }.frame(maxWidth: .infinity)
            Button {
                newItem.price = Int(price) ?? 0
                onAdd(newItem)
            }label: {
                Text("Add")
            }
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(.keyboard)
            .background(Color.yellow)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(){_ in}
    }
}
