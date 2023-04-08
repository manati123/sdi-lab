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
        let name: String
        let description: String
        let price: Int
        let __v: Int
    }
    
    static var instance = API()
    private let url = "https://sdi-lab.herokuapp.com/api/items/"
    
    func getItems(_ callback:@escaping ([Item])->Void) {
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let items):
                do {
                    let decodedItems = try JSONDecoder().decode([Item].self, from: items)
                    print(decodedItems)
                    callback(decodedItems)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func addItem(_ item: Item, _ callback:@escaping ()->Void) {
        let parameters: [String: Any] = [
            "name": item.name,
            "description": item.description,
            "price": item.price
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                callback()
            }
            
        }
    }
    
    func deleteItem(by id: String) {
        AF.request("\(url)/\(id)", method: .delete).responseData { response in
            switch response.result {
            case .failure:
                print("No item with such id")
            case .success(let message):
                print(message)
            }
        }
    }
    
    func updateItem(with id: String, _ item: Item) {
        let parameters: [String: Any] = [
            "name": item.name,
            "description": item.description,
            "price": item.price
        ]
        AF.request("\(url)/\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let item):
                do {
                    let decodedItem = try JSONDecoder().decode(Item.self, from: item)
                    print(decodedItem)
                } catch {
                    print(error)
                }
            }
            
        }
    }
    
    
}
