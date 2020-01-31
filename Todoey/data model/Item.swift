//
//  Item.swift
//  Todoey
//
//  Created by Ajay Vandra on 1/31/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
