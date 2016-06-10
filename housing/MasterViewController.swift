//
//  MasterViewController.swift
//  housing
//
//  Created by Josh Burgin on 5/26/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISplitViewControllerDelegate, UIApplicationDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var schedule = Schedule()
    
    var email : String?

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
        if let fetchEmail = self.email {
            Retriever.getSchedule(fetchEmail) { data, error in
                
                if let schedule = data {
                    self.schedule.removeAll()
                    for (_, subJson) in schedule["events"] {
                        if let newEvent = Event.build(subJson) {
                            self.schedule.addEvent(newEvent)
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
        if segue.identifier == "showEvent" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let event = self.schedule.days[indexPath.section].events[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.event = event
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.schedule.days.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedule.days[section].events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell

        let event = schedule.days[indexPath.section].events[indexPath.row]
        
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCellWithIdentifier("SectionHeader") as! SectionHeaderTableViewCell
        
        sectionHeader.titleLabel.text = self.schedule.days[section].name
        
        return sectionHeader
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }

}

