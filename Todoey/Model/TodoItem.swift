//
//  Item.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/7/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
