//
//  UpdateView.swift
//  webceva
//
//  Created by Silviu Preoteasa on 08.04.2023.
//

import SwiftUI

struct UpdateView: View {
    @Binding var item: API.Item
    @State var name: String = ""
    @State var description: String = ""
    @State var price: Int = 0
    
    let onUpdate: (API.Item)->Void
    var body: some View {
            VStack {
                Text("Update View")
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        TextField("Name: \(item.name)", text: $item.name)
                        TextField("Description: \(item.description)", text: $item.description)
                        TextField("Price: \(item.price)", value: $item.price, format: .number)
                            .keyboardType(.numberPad)
                    }
                    Spacer()
                }.frame(maxWidth: .infinity)
                    .background(Color.green)
                Button {
                    print(item)
                        onUpdate(item)
                }label: {
                    Text("Update")
                }
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            .ignoresSafeArea(.keyboard)
            .background(Color.yellow)
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView(item: .constant(.init(_id: "", name: "", description: "", price: 0, __v: 0))){_ in}
    }
}
