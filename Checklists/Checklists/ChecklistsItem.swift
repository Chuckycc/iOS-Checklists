//
//  ChecklistsItem.swift
//  Checklists
//
//  Created by 袁晨曦 on 2017/3/17.
//  Copyright © 2017年 YYYYCX. All rights reserved.
//

import Foundation

class ChecklistsItem : NSObject,NSCoding {
    var text = ""
    var checked = false
    
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
}




