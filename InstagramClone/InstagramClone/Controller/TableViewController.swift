//
//  TableViewController.swift
//  InstagramClone
//
//  Created by Ing. Richard José David González on 4/2/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit
import Parse

/**
    ViewController to list users. Implements UITableViewController.
*/
class TableViewController: UITableViewController {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
        
    //MARK: - Objects, Variables and Constants
    
    ///List of usernames.
    var userNames: [String] = [String]()
    
    ///List of userIds.
    var userIds: [String] = [String]()
    
    ///List to see who is following an user.
    var isFollowing: [String:Bool] = [String:Bool]()
    
    ///Control to refresh the table.
    var refreshed: UIRefreshControl = UIRefreshControl()
    
    ///Variable to store the number of people followed.
    var numberOfPeopleFollowed: Int = 0
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to close session.
    @IBAction func logOut(sender: UIBarButtonItem) {
        self.presentViewController(self.confirmationMessage("Confirmation", message: "Do you want to log off?"), animated: true, completion: nil)
    }
    
    //MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurationTableView()
        self.initialSetup()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userNames.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = self.userNames[indexPath.row]
        
        let userId: String = self.userIds[indexPath.row]
        
        if self.isFollowing[userId] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        self.configurationActivityIndicator(true)
        
        guard cell.accessoryType.rawValue == UITableViewCellAccessoryType.Checkmark.rawValue else {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.insertFollowing(self.userIds[indexPath.row], follower: PFUser.currentUser()!.objectId!)
            
            return
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        self.stopFollowing(userIds[indexPath.row])
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Methods: Self.
    
    ///Configuration initial of View.
    private func initialSetup(){
        
        self.configurationActivityIndicator(true)
    
        let query: PFQuery? = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock { (pfObjects, error) -> Void in
            
            guard error == nil else {
                
                self.configurationActivityIndicator(false)
                print("Failed request. Error: \(error)")
                return
                
            }
            
            if let users: [PFObject] = pfObjects {
                
                for object in users {
                    
                    if let user: PFUser = object as? PFUser {
                    
                        if user.objectId != PFUser.currentUser()?.objectId {
                            
                            self.userNames.append(user.username!)
                            self.userIds.append(user.objectId!)
                            
                            let query: PFQuery = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                        
                            query.findObjectsInBackgroundWithBlock({ (pfObjects, error) -> Void in
                                
                                if let objects: [PFObject] = pfObjects {
                                    
                                    if objects.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                    
                                }
                                
                                if self.isFollowing.count == self.userNames.count {
                                    
                                    self.tableView.reloadData()
                                    self.configurationActivityIndicator(false)
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
            
            }
            
            if self.activityIndicator.isAnimating() == true {
                self.configurationActivityIndicator(false)
            }
            
        }
    
    }
    
    ///Function to insert following.
    private func insertFollowing(followingNow: String, follower: String) {
        
        let following: PFObject = PFObject(className: "followers")
        following["following"] = followingNow
        following["follower"] = follower
        
        following.saveInBackgroundWithBlock { (status, error) -> Void in
            
            self.configurationActivityIndicator(false)
            
            guard error == nil else {
                
                print("Failed request. Error \(error)")
                return
                
            }
            
        }
        
    }
    
    ///Function to stop following an user.
    private func stopFollowing(userId: String) {
        
        let query: PFQuery = PFQuery(className: "followers")
        query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        query.whereKey("following", equalTo: userId)
        
        query.findObjectsInBackgroundWithBlock({ (pfObjects, error) -> Void in
            
            if let objects: [PFObject] = pfObjects {
                
                for object in objects {
                    
                    object.deleteInBackgroundWithBlock({ (status, error) -> Void in
                        
                        self.configurationActivityIndicator(false)
                        
                        guard error == nil else {
                        
                            print("Failed request. Error \(error)")
                            return
                            
                        }
                        
                    })
                    
                }
                
            }
            
        })
        
    }
    
    ///Configuration of activityIndicator.
    private func configurationActivityIndicator(status: Bool) {
    
        switch (status) {
        
        case true:
            
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            break
            
        case false:
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            break
            
        }
    
    }
    
    ///Configuration of tableView.
    private func configurationTableView() {
    
        self.refreshed.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        self.refreshed.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshed)
        
        self.activityIndicator.frame = self.view.frame
        self.activityIndicator.center = CGPointMake(tableView.frame.width/2, tableView.frame.height/2)
        self.tableView.addSubview(self.activityIndicator)
    
    }
    
    ///Function to refresh the data in the table.
    func refresh() {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let query: PFQuery? = PFUser.query()
        
        self.isFollowing.removeAll(keepCapacity: true)
        self.userNames.removeAll(keepCapacity: true)
        
        query?.findObjectsInBackgroundWithBlock { (pfObjects, error) -> Void in
            
            guard error == nil else {
                
                print("Failed request. Error: \(error)")
                return
                
            }
            
            if let users: [PFObject] = pfObjects {
                
                for object in users {
                    
                    if let user: PFUser = object as? PFUser {
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            
                            self.userNames.append(user.username!)
                            self.userIds.append(user.objectId!)
                            
                            let query: PFQuery = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (pfObjects, error) -> Void in
                                
                                if let objects: [PFObject] = pfObjects {
                                    
                                    if objects.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                    
                                }
                                
                                if self.isFollowing.count == self.userNames.count {
                                    
                                    self.tableView.reloadData()
                                    self.refreshed.endRefreshing()
                                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    //Function to generate a basic confirmation message..
    private func confirmationMessage(title: String, message: String) -> UIAlertController {
    
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let actionAccept: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            
            PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
                
                guard error == nil else {
                
                    print("Failed request! Error: \(error)")
                    return
                
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                self.presentViewController(nextViewController, animated:true, completion:nil)
                
            })
            
        }
        let actionCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(actionCancel)
        alertController.addAction(actionAccept)
        
        return alertController
    
    }

}
