//
//  MasterViewController.swift
//  housing
//
//  Created by Josh Burgin on 5/26/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISplitViewControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()

    @IBOutlet weak var header: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureView()
    }
    
    func configureView() {
        splitViewController?.delegate = self
        refreshControl?.addTarget(self, action: #selector(MasterViewController.refreshSchedule), forControlEvents: .ValueChanged)
        refreshControl?.tintColor = UIColor.lightGrayColor()
        refreshSchedule()
        
        tableView.rowHeight = 64
        
    }
    
    func refreshSchedule() {
        Retriever.getSchedule("dwzheng@crimson.ua.edu") { data, error in
            
            if let schedule = data {
                self.objects.removeAll()
                for (_, subJson) in schedule["events"] {
                    if let newEvent = Event.build(subJson) {
                        self.objects.append(newEvent)
                    }
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
            
            if let err = error {
                print(err)
                self.refreshControl?.endRefreshing()
            }
            
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell

        let event = objects[indexPath.row] as! Event
        cell.titleLabel.text = event.title
        cell.timeLabel.text = "\(event.startTime)"
        
        if let eventEndTime = event.endTime {
            
            if eventEndTime != "" {
                cell.timeLabel.text = "\(event.startTime) - \(eventEndTime)"
            }
            
        }
        
        cell.locationLabel.text = "@ \(event.location)"
        
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
    
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }

}

