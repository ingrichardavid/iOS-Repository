//
//  TableViewController.swift
//  Memorable Place
//
//  Created by Ing. Richard José David González on 14/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

///Protocol to be implemented in class TableViewController.
protocol tableViewControllerDelegate {

    ///A method for recharging table.
    func reloadData()

}

///Global variable to store the memorable places. 
var places: [Dictionary<String,String>] = [Dictionary<String,String>()]

///Indicates whether you selected a place of TableView.
var activePlace: Int = -1

/**
    Class that contains the necessary tools to manage the view that shows the places. Implements UITableViewController and tableViewControllerDelegate.
*/
class TableViewController: UITableViewController, tableViewControllerDelegate {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet var table: UITableView!
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (places.count == 1) {
            
            places.removeAtIndex(0)
            places.append(["name":"Salto Ángel - Venezuela.","latitude":"5.968902","longitude":"-62.535682"])
        
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.table.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = places[indexPath.row]["name"]

        return cell
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activePlace = indexPath.row
        
        return indexPath
        
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "newPlace") {
            activePlace = -1
        }
        
        let viewController = segue.destinationViewController as! ViewController
        viewController.tableViewDelegate = self
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: - Methods: TableViewControllerDelegate
    
    func reloadData() {
        self.table.reloadData()
    }

}
