//
//  Data.swift
//  Todoey
//
//  Created by Olar's Mac on 2/7/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
