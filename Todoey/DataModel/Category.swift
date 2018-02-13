//
//  Category.swift
//  Todoey
//
//  Created by Olar's Mac on 2/7/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    // relationship with Items
    // List is d substitute for array in Realm
    let items = List<Item>()
    
}
