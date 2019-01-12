//
//  Category.swift
//  Todoey
//
//  Created by Sikorskiy Yaroslav on 1/7/19.
//  Copyright © 2019 Sikorskiy Yaroslav. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<TodoItem>()
}
