//
//  UsersTableVC.swift
//  UsingCoreData
//
//  Created by Ing. Richard José David González on 18/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Class responsible for managing user table view. Implements UITableViewController.
*/
class UsersTableVC: UITableViewController {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
  
    @IBOutlet var table: UITableView!
    
    ///Containing class services to manipulate data in the CoreData USER_DATA entity.
    let cdUserdata: CDUserData = CDUserData()
    
    ///Array for storing all users of the database.
    var users: [UserData]?
    
    ///Variable to store the index of the table to be deleted.
    var deleteUserIndexPath: NSIndexPath? = nil
    
    ///Object to store user data selected from the table.
    var user: UserData?
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.users = self.cdUserdata.findUsers()
        
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
        return (self.users?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.lblName.text = " \(self.users![indexPath.row].name!)"
        cell.lblAddress.text = " \(self.users![indexPath.row].address!)"
        cell.lblPhone.text = " \(self.users![indexPath.row].phone!)"

        return cell
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        self.user = self.users![indexPath.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("UserDataVC") as! UserDataVC
        nextViewController.userData = self.user
        self.presentViewController(nextViewController, animated:true, completion:nil)

        return indexPath
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.deleteUserIndexPath = indexPath
            self.confirmDelete(self.users![indexPath.row].name!)
            
        }
        
    }
    

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
    
    private func confirmDelete(userName: String) {
    
        let alertController: UIAlertController = UIAlertController(title: "Removing users.", message: "Are you sure you want to delete the user \(userName)", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (actions) -> Void in
            
            self.table.beginUpdates()
            self.cdUserdata.delete(self.users![(self.deleteUserIndexPath?.row)!])
            self.users?.removeAtIndex((self.deleteUserIndexPath?.row)!)
            self.table.deleteRowsAtIndexPaths([self.deleteUserIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.table.endUpdates()
            
            guard self.users?.count > 0 else {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("UserDataVC") as! UserDataVC
                self.presentViewController(nextViewController, animated:true, completion:nil)
                return
                
            }
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (actions) -> Void in
            
            self.deleteUserIndexPath = nil
            
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
