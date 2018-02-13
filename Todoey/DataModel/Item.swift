//
//  Item.swift
//  Todoey
//
//  Created by Olar's Mac on 2/7/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc  dynamic var dateCreated : Date?
    
    // Inverse relationship
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
