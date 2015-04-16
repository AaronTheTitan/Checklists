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
    var checklist: Checklist!

    //MARK: - BEGIN THE CODE

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
        sortItemsByDate()
    }

    // MARK: - DELEGATE METHODS
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {

        let newRowIndex = checklist.items.count
        checklist.items.append(item)

        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

        sortItemsByDate()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {

        if let index = find(checklist.items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)

            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }

        sortItemsByDate()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }

    func sortItemsByDate() {
        checklist.items.sort({ date1, date2 in return date1.dueDate.compare(date2.dueDate) == NSComparisonResult.OrderedAscending })
    }

    // MARK: - TABLEVIEW METHODS
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as! UITableViewCell
        let item = checklist.items[indexPath.row]

        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, item: item)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()

            configureCheckmarkForCell(cell, item: item)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

    }

    // MARK: - CONFIGURATION METHODS
    func configureCheckmarkForCell(cell: UITableViewCell, item: ChecklistItem) {

        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor

        if item.checked {
            label.text = "✅"
        } else {
            label.text = ""
        }
    }

    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text

        let dueByLabel = cell.viewWithTag(1002) as! UILabel
        dueByLabel.text = "Due by: \(item.dateAsString())"
    }

    // MARK: - SEGUES
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "AddItem" {

            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self

        } else if segue.identifier == "EditItem" {

            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self

            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }


}

