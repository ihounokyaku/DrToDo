//
//  Category.swift
//  DrToDo
//
//  Created by Dylan Southard on 2018/04/11.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
