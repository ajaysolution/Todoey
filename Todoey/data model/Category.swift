//
//  Category.swift
//  Todoey
//
//  Created by Ajay Vandra on 1/31/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import Foundation
import RealmSwift

class Category :Object{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
