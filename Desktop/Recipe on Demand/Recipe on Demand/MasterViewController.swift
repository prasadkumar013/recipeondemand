//
//  MasterViewController.swift
//  Recipe on Demand
//
//  Created by Prasad Kumar on 6/25/16.
//  Copyright © 2016 Aadya. All rights reserved.
//

import UIKit

var objects:[String] = [String]()
var currentIndex:Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?
let kRecipe:String = "recipe"
let BLANK_RECIPE:String = "(New Recipe)"

class MasterViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        masterView = self
        load()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        save()
        super.viewWillAppear(animated)
    }
    
    // Add a new recipe when app is opened for first time and there are no entries
    override func viewDidAppear(animated: Bool) {
        if objects.count == 0 {
            insertNewObject(self)
        }
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        if detailViewController?.preperationTextView.editable == false {
            return
        }
        // Make sure that only one blank Recipe is allowed
        if objects.count == 0 || objects[0] != BLANK_RECIPE {
            objects.insert(BLANK_RECIPE, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        // To start adding a new Recipe as soon as '+' button is clicked
        currentIndex = 0
        self.performSegueWithIdentifier("showDetail", sender: self)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        detailViewController?.preperationTextView.editable = true
        if segue.identifier == "showDetail" {
            let nlabelbe = segue.destinationViewController as! UINavigationController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                currentIndex = indexPath.row
            }
            let indxPath = self.tableView.indexPathForSelectedRow
            if indxPath != nil {
            let ccell =  self.tableView.cellForRowAtIndexPath(indxPath!)! as UITableViewCell
            let tlabelbe = nlabelbe.topViewController as! DetailViewController
            print(ccell.textLabel!.text)
            tlabelbe.dishName = ccell.textLabel!.text
        }
            let object = objects[currentIndex]
                detailViewController?.detailItem = object
                detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // Make deleting recipes permanent
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            detailViewController?.preperationTextView.editable = false
            detailViewController?.preperationTextView.text = ""
            return
        }
        save()
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        detailViewController?.preperationTextView.editable = false
        detailViewController?.preperationTextView.text = ""
        save()
    }
    
    // Function to save the recipes to persitant storage
    func save() {
        NSUserDefaults.standardUserDefaults().setObject(objects, forKey: kRecipe)
        // To save new recipes on demand
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // Function to load the recipes from persitant storage
    func load() {
        if let loadedData = NSUserDefaults.standardUserDefaults().arrayForKey(kRecipe) as? [String] {
        objects = loadedData
        }
        
    }

}

