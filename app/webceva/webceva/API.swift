//
//  API.swift
//  webceva
//
//  Created by Silviu Preoteasa on 07.04.2023.
//

import Foundation
import Alamofire

class API {
    struct Item: Codable, Hashable {
        let _id: String
        var name: String
        var description: String
        var price: Int
        let __v: Int
    }
    
    struct Message: Codable {
        let message: String
    }
    
    static var instance = API()
    private let url = "https://sdi-lab.herokuapp.com/api/items/"
    
    func getItems(_ callback:@escaping ([Item])->Void) {
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error):
                ViewModel.showMessage(message: error.localizedDescription)
            case .success(let items):
                do {
                    let decodedItems = try JSONDecoder().decode([Item].self, from: items)
                    print(decodedItems)
                    callback(decodedItems)
                } catch {
                    ViewModel.showMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    func addItem(_ item: Item, _ callback:@escaping (Item)->Void) {
        let parameters: [String: Any] = [
            "name": item.name,
            "description": item.description,
            "price": item.price
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error):
                ViewModel.showMessage(message: error.localizedDescription)
            case .success(let item):
                do {
                    let decodedItem = try JSONDecoder().decode(Item.self, from: item)
                    print(decodedItem)
                    callback(decodedItem)
                } catch {
                    ViewModel.showMessage(message: error.localizedDescription)
                }
            }
            
        }
    }
    
    func deleteItem(by id: String, _ callback:@escaping ()->Void) {
        AF.request("\(url)\(id)", method: .delete).responseData { response in
            switch response.result {
            case .failure:
                ViewModel.showMessage(message: "No item with such id")
            case .success(let message):
                do {
                    let decodedMessage = try JSONDecoder().decode(Message.self, from: message)
                    ViewModel.showMessage(message: decodedMessage.message)
                    callback()
                } catch {
                    ViewModel.showMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    func updateItem(with id: String, _ item: Item, _ callback:@escaping (Item)->Void) {
        let parameters: [String: Any] = [
            "name": item.name,
            "description": item.description,
            "price": item.price
        ]
        AF.request("\(url)\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error):
                ViewModel.showMessage(message: error.localizedDescription)
            case .success(let item):
                do {
                    let decodedItem = try JSONDecoder().decode(Item.self, from: item)
                    callback(decodedItem)
                } catch {
                    ViewModel.showMessage(message: error.localizedDescription)
                }
            }
            
        }
    }
    
    
}
