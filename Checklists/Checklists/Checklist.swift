//
//  Checklist.swift
//  Checklists
//
//  Created by 袁晨曦 on 2017/3/18.
//  Copyright © 2017年 YYYYCX. All rights reserved.
//

import UIKit

class Checklist: NSObject,NSCoding {
    var name = ""
    var items = [ChecklistsItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistsItem]
        super.init()
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }

}
