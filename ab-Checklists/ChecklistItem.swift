//
//  ChecklistItem.swift
//  ab-Checklists
//
//  Created by Aaron Bradley on 3/16/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import Foundation

class ChecklistItem : NSObject, NSCoding {
    var text = ""
    var checked = false

    func toggleChecked() {
        checked = !checked
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }

    required init(coder aDecoder: NSCoder) {
        super.init()

        text = aDecoder.decodeObjectForKey("Text") as String
        checked = aDecoder.decodeBoolForKey("Checked")
    }

    override init() {
        super.init()
    }
}