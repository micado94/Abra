//
//  OlohApiClient.swift
//  Oloh
//
//  Created by Baptiste Jacob on 10/28/17.
//  Copyright © 2017 oloh. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class OlohApiClient {
    let headers: HTTPHeaders
    let olohUrl: String
    
    init() {
        // setting url and route
        self.olohUrl = "https://oloh.fr"
        
        // generating token for basic auth
        let user = "ck_fb2a39bf26ad4535b96a3d4e3a518e9378825148"
        let password = "cs_3709ea5013a44e175a5079bd67204f092a4a2d5e"
        
        let utf8str = "\(user):\(password)".data(using: String.Encoding.utf8)
        let token = utf8str!.base64EncodedString()
        
        // setting up headers
        self.headers = [
            "Authorization": "Basic \(token)",
            "Accept": "application/json"
        ]
    }
    
    func syncAllCategories() {
        Alamofire.request(
            "\(self.olohUrl)/wp-json/wc/v2/products/categories?per_page=100",
            headers: headers
            ).responseJSON { (response) -> Void in
                
                if let JSON = response.result.value as! [[String: Any]]? {
                    for elem in JSON {
                        
                        var newCategory = Category()
                        newCategory.slug = elem["slug"] as? String
                        newCategory.menu_order = elem["menu_order"] as? NSInteger
                        newCategory.category_description = elem["category_description"] as? String
                        newCategory.image = elem["image"] as? Any
                        newCategory.count = elem["count"] as? NSInteger
                        newCategory.parent = elem["parent"] as? NSInteger
                        newCategory.id = elem["id"] as? NSInteger
                        newCategory.display = elem["display"] as? String
                        newCategory.category_name = elem["name"] as? String
                        newCategory.writeToRealm()
                    }
                }
                    
        }
    }
    
    func syncAllProducts() {
        Alamofire.request(
            "\(self.olohUrl)/wp-json/wc/v2/products?per_page=100",
            headers: headers
            ).responseJSON { (response) -> Void in
                
                if let JSON = response.result.value as! [[String: Any]]? {
                    for elem in JSON {
                        
                        print("\(elem)")
                        
                    }
                }
                
        }
    }
}
