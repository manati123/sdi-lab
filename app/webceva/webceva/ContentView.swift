//
//  ContentView.swift
//  webceva
//
//  Created by Silviu Preoteasa on 07.04.2023.
//

import SwiftUI
import SwiftMessages

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
            
        placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(.gray) }
    }
}

class ViewModel: ObservableObject {
    @Published var items: [API.Item] = []
    
    func getItems() {
        API.instance.getItems() { [weak self] items in
            self?.items = items
            
        }
    }
    
    func addItem(item: API.Item, _ callback:@escaping ()->Void) {
        API.instance.addItem(item) { [weak self] item in
            self?.items.append(item)
            callback()
        }
    }
    
    func deleteItem(id: String) {
        API.instance.deleteItem(by: id) { [weak self] in
            self?.items.removeAll(where: {$0._id == id})
        }
    }
    
    func updateItem(_ item: API.Item) {
        API.instance.updateItem(with: item._id, item) { [weak self] updatedItem in
            let index = self?.items.firstIndex(where: {$0._id == item._id})
            if let index {
                self?.items[index] = updatedItem
            }
        }
    }
    
    static func showMessage(message: String) {
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .cardView)

        // Theme message elements with the warning style.
        view.configureTheme(.warning)

        // Add a drop shadow.
        view.configureDropShadow()

        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
        view.configureContent(title: "Message", body: message, iconText: iconText)
        view.button?.isHidden = true
        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        // Show the message.
        SwiftMessages.show(view: view)
    }
    
    
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    @State var showAddSheet: Bool = false
    @State var showUpdateSheet: Bool = false
    @State var selectedItem: API.Item = .init(_id: "", name: "", description: "", price: 0, __v: 0)
    var body: some View {
        VStack(spacing: 24) {
                Button {
                    showAddSheet = true
                } label: {
                    Text("Add new item")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }.background(RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(.blue))
                .padding(.horizontal, 16)
                
                
            
            ScrollView {
                ForEach(viewModel.items, id:\.self) { item in
                    HStack(spacing: 24) {
                        Text(item._id)
                        Text(item.name)
                        Text(item.description)
                        Text("\(item.price)")
                        Button {
                            
                                if item._id == selectedItem._id {
                                    self.selectedItem = .init(_id: "", name: "", description: "", price: 0, __v: 0)
                                }
                            
                            viewModel.deleteItem(id: item._id)
                        }label: {
                            Image(systemName: "trash")
                                .renderingMode(.template)
                                .foregroundColor(.red)
                        }
                        Button {
                            selectedItem = item
                            print("\n\n\(selectedItem)\n\n")
                            showUpdateSheet = true
                        } label: {
                            Text("Update")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        }.background(RoundedRectangle(cornerRadius: 14)
                            .foregroundColor(.yellow))
                    }.frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    .foregroundColor(.black)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .onAppear {
                viewModel.getItems()
            }
            .sheet(isPresented: $showUpdateSheet) {
                
                    UpdateView(item: $selectedItem) { updatedItem in
                        viewModel.updateItem(updatedItem)
                        self.showUpdateSheet = false
                    }
            }
            .sheet(isPresented: $showAddSheet) {
                AddView() { item in
                    viewModel.addItem(item: item) {
                        self.showAddSheet = false
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
