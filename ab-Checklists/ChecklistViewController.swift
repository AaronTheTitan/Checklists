//
//  ViewController.swift
//  ab-Checklists
//
//  Created by Aaron Bradley on 3/16/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

    //MARK: - PROPERTIES
    var items = [ChecklistItem]()
    var checklist: Checklist!

    //MARK: - BEGIN THE CODE
    required init(coder aDecoder: NSCoder) {

        items = [ChecklistItem]()

        super.init(coder: aDecoder)
        loadChecklistItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
    }

    // MARK: - DELEGATE METHODS
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {

        let newRowIndex = items.count
        items.append(item)

        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

        saveChecklistItems()

        dismissViewControllerAnimated(true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {

        if let index = find(items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)

            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }

        saveChecklistItems()

        dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - SAVE/LOAD METHODS
    func documentsDirectory() ->String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }

    func dataFilePath() ->String {
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }

    func loadChecklistItems() {
        let path = dataFilePath()

        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                items = unarchiver.decodeObjectForKey("ChecklistItems") as [ChecklistItem]
                unarchiver.finishDecoding()
            }
        }
    }

    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }


    // MARK: - TABLEVIEW METHODS
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

        saveChecklistItems()
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

        saveChecklistItems()

    }

    // MARK: - CONFIGURATION METHODS
    func configureCheckmarkForCell(cell: UITableViewCell, item: ChecklistItem) {

        let label = cell.viewWithTag(1001) as UILabel

        if item.checked {
            label.text = "✅"
        } else {
            label.text = ""
        }
    }

    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
    }

    // MARK: - SEGUES
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "AddItem" {

            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            controller.delegate = self

        } else if segue.identifier == "EditItem" {

            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            controller.delegate = self

            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }




}

