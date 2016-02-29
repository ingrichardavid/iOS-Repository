//
//  FeedTableViewController.swift
//  InstagramClone
//
//  Created by Ing. Richard José David González on 11/2/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit
import Parse

/**
 Implements UITableViewController. This class provides an infrastructure for managing the feedTableViewController view.
 */
class FeedTableViewController: UITableViewController {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
        
    //MARK: - Objects, Variables and Constants
    
    ///Array to store messages.
    var messages: [String] = [String]()
    
    ///Array to store usernames.
    var userNames: [String] = [String]()
    
    ///Array to store image files.
    var imageFiles: [PFFile] = [PFFile]()
    
    ///Dictionary for storing user data.
    var users: [String : String] = [String : String]()
    
    ///Control to refresh the table.
    var refreshed: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Methods: UIViewController.
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        self.imageFiles[indexPath.row].getDataInBackgroundWithBlock { (nsData, error) -> Void in
            
            guard error == nil else {
                
                print("Failed request. Error: \(error)")
                return
                
            }
            
            if let downloadedImage: UIImage = UIImage(data: nsData!) {
                cell.postedImage.image = downloadedImage
            }
            
        }
        
        cell.postedImage.image = UIImage(named: "image")
        cell.userName.text = self.userNames[indexPath.row]
        cell.message.text = self.messages[indexPath.row]
        
        return cell
        
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
                    
                    if let user = object as? PFUser {
                        self.users[user.objectId!] = user.username!
                    }
                    
                }
                
            }
            
        }
        
        let getFollowedUsersQuery: PFQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (pfObjects, error) -> Void in
            
            guard error == nil else {
                
                self.configurationActivityIndicator(false)
                print("Failed request. Error: \(error)")
                return
                
            }
            
            if let objects: [PFObject] = pfObjects {
                
                for object in objects {

                    let followedUser: String = object["following"] as! String
                    let query: PFQuery = PFQuery(className: "Post")
                    query.whereKey("userId", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock({ (pfObjects, error) -> Void in
                        
                        guard error == nil else {
                            
                            self.configurationActivityIndicator(false)
                            print("Failed request. Error: \(error)")
                            return
                            
                        }
                        
                        if let objects: [PFObject] = pfObjects {
                        
                            for object in objects {
                            
                                self.messages.append(object["message"] as! String)
                                self.imageFiles.append(object["imageFile"] as! PFFile)
                                self.userNames.append(self.users[object["userId"] as! String]!)
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                        
                    })
                    
                }
                
                self.configurationActivityIndicator(false)
                
            }
            
        }
    
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
        
        self.users.removeAll(keepCapacity: true)
        
        query?.findObjectsInBackgroundWithBlock { (pfObjects, error) -> Void in
            
            guard error == nil else {
                
                self.configurationActivityIndicator(false)
                print("Failed request. Error: \(error)")
                return
                
            }
            
            if let users: [PFObject] = pfObjects {

                for object in users {
                    
                    if let user = object as? PFUser {
                        self.users[user.objectId!] = user.username!
                    }
                    
                }
                
            }
            
        }
        
        let getFollowedUsersQuery: PFQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (pfObjects, error) -> Void in
            
            guard error == nil else {
                
                self.refreshed.endRefreshing()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                print("Failed request. Error: \(error)")
                return
                
            }
            
            if let objects: [PFObject] = pfObjects {
                
                self.messages.removeAll()
                self.userNames.removeAll()
                self.imageFiles.removeAll()
                
                for object in objects {
                    
                    let followedUser: String = object["following"] as! String
                    let query: PFQuery = PFQuery(className: "Post")
                    query.whereKey("userId", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock({ (pfObjects, error) -> Void in
                        
                        guard error == nil else {
                            
                            self.refreshed.endRefreshing()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            print("Failed request. Error: \(error)")
                            return
                            
                        }
                        
                        if let objects: [PFObject] = pfObjects {
                            
                            for object in objects {
                                
                                self.messages.append(object["message"] as! String)
                                self.imageFiles.append(object["imageFile"] as! PFFile)
                                self.userNames.append(self.users[object["userId"] as! String]!)
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                        
                    })
                    
                }
                
                self.refreshed.endRefreshing()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            }
            
        }
        
    }

}
