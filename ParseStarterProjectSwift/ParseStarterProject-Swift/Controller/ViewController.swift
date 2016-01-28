/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

/**
    ViewController responsible for managing register, edit, delete and find products. Implements UIViewController, UITextFieldDelegate.
*/
class ViewController: UIViewController
, UITextFieldDelegate, UITableViewDataSource {
    
    //MARK: - Connecting elements storyboard: IBOutlet.

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnItemAdd: UIBarButtonItem!
    @IBOutlet weak var btnItemEdit: UIBarButtonItem!
    @IBOutlet weak var btnItemCancel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Objects, Variables and Constants.
    
    ///Product selected of table.
    var product: Product = Product()
    
    ///Products store in the Parse.
    var products = [Product]()
    
    ///Variable to store the index of the table to be deleted.
    var deleteProductIndexPath: NSIndexPath? = nil
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to hide the keyboard to touch any part of the view.
    @IBAction func closeKeyBoard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    ///Function to add a product.
    @IBAction func addProduct(sender: UIBarButtonItem) {
    
        guard self.validateFields() == true else {
            return
        }
        
        let product: Product = Product(name: txtName.text!, description: txtDescription.text!, price: txtPrice.text!)
        self.create(product)
    
    }
    
    ///Function to modify a product.
    @IBAction func modifyProduct(sender: UIBarButtonItem) {
        
        guard self.validateFields() == true else {
            return
        }
        
        let product: Product = Product(code: self.product.code!, name: txtName.text!, description: txtDescription.text!, price: txtPrice.text!)
        self.update(product)
        
    }
    
    ///Function to return to the initial configuration.
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.configurationInitial()
    }
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.products = self.selectAll()
        self.configurationInitial()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods: UITableViewDataSource.
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        cell.lblName.text = self.products[indexPath.row].name
        cell.lblDescription.text = self.products[indexPath.row].description
        cell.lblPrice.text = self.products[indexPath.row].price
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        self.product = self.products[indexPath.row]

        self.txtName.text = self.product.name
        self.txtDescription.text = self.product.description
        self.txtPrice.text = self.product.price
        self.btnItemAdd.enabled = false
        self.btnItemEdit.enabled = true
        
        return indexPath
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.deleteProductIndexPath = indexPath
            self.confirmDelete(self.products[indexPath.row].code!)
            
        }
        
    }
    
    //MARK: - Methods: UITextFieldDelegate.
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard textField != self.txtName else {
            
            let newString: NSString = (self.txtName.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 50
            
        }
        
        guard textField != self.txtDescription else {
            
            let newString: NSString = (self.txtDescription.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 100
            
        }
        
        guard textField != self.txtPrice else {
            
            let newString: NSString = (self.txtPrice.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 20
            
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    //MARK: - Services.
    
    ///Services to create products.
    private func create(product: Product) {
        
        let entity: PFObject = PFObject(className: ParseStructureEntities.product.name_entity.rawValue)
        entity[ParseStructureEntities.product.name.rawValue] = product.name!
        entity[ParseStructureEntities.product.description.rawValue] = product.description!
        entity[ParseStructureEntities.product.price.rawValue] = product.price!
        
        entity.saveInBackgroundWithBlock { (success, error) -> Void in
            
            guard error == nil else {
                
                self.presentViewController(self.informationMessage("Failed to register. Error: \(error)"), animated: true, completion: nil)
                return
                
            }
            
            guard success == true else {
                
                self.presentViewController(self.informationMessage("Failed to register."), animated: true, completion: nil)
                return
                
            }
            
            self.presentViewController(self.informationMessage("Registered product!"), animated: true, completion: nil)
            self.configurationInitial()
            self.products = self.selectAll()
            self.tableView.reloadData()
            
        }
        
    }
    
    ///Services to find a product.
    private func select(code: String) {
    
        let query: PFQuery = PFQuery(className: ParseStructureEntities.product.name_entity.rawValue)

        query.getObjectInBackgroundWithId(code) { (pfObject, error) -> Void in
            
            guard error == nil else {
                
                self.presentViewController(self.informationMessage("Failed to search. Error: \(error)"), animated: true, completion: nil)
                return
                
            }
            
            guard let objectReturned: PFObject = pfObject else {
                
                self.presentViewController(self.informationMessage("Failed to search."), animated: true, completion: nil)
                return
                
            }
            
            let product: Product = Product(anyObject: objectReturned)
            print(product.name!)
            print(product.description!)
            print(product.price!)
            
        }
        
    }
    
    ///Services to find products.
    private func selectAll() -> [Product] {
        
        var products = [Product]()
        let query: PFQuery = PFQuery(className: ParseStructureEntities.product.name_entity.rawValue)
        
        do{
            
            let pfObjects: [PFObject] = try query.findObjects()

            for pfObject in pfObjects {
                
                let product: Product = Product(anyObject: pfObject)
                products.append(product)
                
            }
            
            return products
            
        } catch {
            print("Failed to find!")
        }
        
        return products
                
    }
    
    ///Services to modify products.
    private func update(product: Product) {
        
        let query: PFQuery = PFQuery(className: ParseStructureEntities.product.name_entity.rawValue)

        query.getObjectInBackgroundWithId(product.code!) { (pfObject, error) -> Void in
            
            guard error == nil else {
                
                self.presentViewController(self.informationMessage("Failed to search. Error: \(error)"), animated: true, completion: nil)
                return
                
            }
            
            guard let objectReturned: PFObject = pfObject else {
                
                self.presentViewController(self.informationMessage("Failed to search."), animated: true, completion: nil)
                return
                
            }
            
            objectReturned[ParseStructureEntities.product.name.rawValue] = product.name!
            objectReturned[ParseStructureEntities.product.description.rawValue] = product.description!
            objectReturned[ParseStructureEntities.product.price.rawValue] = product.price!
            objectReturned.saveInBackgroundWithBlock({ (success, error) -> Void in
                
                guard error == nil else {
                    
                    self.presentViewController(self.informationMessage("Failed to update. Error: \(error)"), animated: true, completion: nil)
                    return
                    
                }
                
                guard success == true else {
                    
                    self.presentViewController(self.informationMessage("Failed to update."), animated: true, completion: nil)
                    return
                    
                }
                
                self.presentViewController(self.informationMessage("Modified product!"), animated: true, completion: nil)
                self.products = self.selectAll()
                self.tableView.reloadData()
                self.configurationInitial()
                
            })
            
        }
        
    }
    
    ///Services to remove products.
    private func deleteProduct(code: String) {
        
        let query: PFQuery = PFQuery(className: ParseStructureEntities.product.name_entity.rawValue)
        
        query.getObjectInBackgroundWithId(code) { (pfObject, error) -> Void in
            
            guard error == nil else {
                
                self.presentViewController(self.informationMessage("Failed to search. Error: \(error)"), animated: true, completion: nil)
                return
                
            }
            
            guard let objectReturned: PFObject = pfObject else {
                
                self.presentViewController(self.informationMessage("Failed to search."), animated: true, completion: nil)
                return
                
            }
            
            objectReturned.deleteInBackgroundWithBlock({ (success, error) -> Void in
                
                guard error == nil else {
                    
                    self.presentViewController(self.informationMessage("Failed to delete. Error: \(error)"), animated: true, completion: nil)
                    return
                    
                }
                
                guard success == true else {
                    
                    self.presentViewController(self.informationMessage("Failed to delete."), animated: true, completion: nil)
                    return
                    
                }
                
            })
            
        }
        
    }
    
    //MARK: - Methods: Self.
    
    ///Configuration initial.
    private func configurationInitial() {
    
        self.btnItemAdd.enabled = true
        self.btnItemEdit.enabled = false
        self.btnItemCancel.enabled = true
        self.txtName.text = ""
        self.txtDescription.text = ""
        self.txtPrice.text = ""
        self.view.endEditing(true)
    
    }
    
    ///Function to validate that the required fields are completed.
    private func validateFields() -> Bool {
        
        guard self.txtName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.txtName.becomeFirstResponder()
            return false
            
        }
        
        guard self.txtDescription.text?.isEmpty == false else {
            
            self.txtDescription.becomeFirstResponder()
            return false
            
        }
        
        guard self.txtPrice.text?.isEmpty == false else {
            
            self.txtPrice.becomeFirstResponder()
            return false
            
        }
        
        return true
        
    }
    
    ///Basic function to issue an information message.
    private func informationMessage(message: String) -> UIAlertController {
    
        let alertController: UIAlertController = UIAlertController(title: "Information message.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(acceptAction)
        
        return alertController
        
    }
    
    ///Function to confirm removal process.
    private func confirmDelete(code: String) {
        
        let alertController: UIAlertController = UIAlertController(title: "Removing product.", message: "Are you sure you want to delete the product?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (actions) -> Void in
            
            self.tableView.beginUpdates()
            self.deleteProduct(self.products[self.deleteProductIndexPath!.row].code!)
            self.products.removeAtIndex((self.deleteProductIndexPath?.row)!)
            self.tableView.deleteRowsAtIndexPaths([self.deleteProductIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (actions) -> Void in
            
            self.deleteProductIndexPath = nil
            
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
