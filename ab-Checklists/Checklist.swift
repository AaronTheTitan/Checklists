//
//  Checklst.swift
//  ab-Checklists
//
//  Created by Aaron Bradley on 3/20/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import UIKit

class Checklist: NSObject {
   var name = ""

    init(name: String) {
        self.name = name
        super.init()
    }
}
