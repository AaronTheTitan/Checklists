//
//  ViewController.swift
//  ab-Checklists
//
//  Created by Aaron Bradley on 3/16/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    //MARK: - PROPERTIES
    var items = [ChecklistItem]()


    //MARK: - BEGIN THE CODE
    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        let row0item = ChecklistItem()
        row0item.text = "Walk the dumb dog"
        row0item.checked = false
        items.append(row0item)

        let row1item = ChecklistItem()
        row1item.text = "Brush ma teeth"
        row1item.checked = false
        items.append(row1item)

        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = false
        items.append(row2item)

        let row3item = ChecklistItem()
        row3item.text = "Soccer Practice"
        row3item.checked = false
        items.append(row3item)

        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = false
        items.append(row4item)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

//    @IBAction func addItem() {
//
//        let newRowIndex = items.count
//        let item = ChecklistItem()
//
//        item.text = "I am a new row"
//        item.checked = false
//
//        items.append(item)
//
//        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
//        let indexPaths = [indexPath]
//
//        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
        let item = items[indexPath.row]

        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, item: item)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()

            configureCheckmarkForCell(cell, item: item)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

    }

    func configureCheckmarkForCell(cell: UITableViewCell, item: ChecklistItem) {

        if item.checked {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }

    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
    }






}

