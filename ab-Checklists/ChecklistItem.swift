//
//  ChecklistItem.swift
//  ab-Checklists
//
//  Created by Aaron Bradley on 3/16/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false

    func toggleChecked() {
        checked = !checked
    }
}