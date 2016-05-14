//
//  ControllerConsultCountry
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/**
 Class responsible for administering the necessary methods of the view consult country. Implements UIViewController, UITableViewDataSource, UITableViewDelegate and UITextFieldDelegate.
 */
class ControllerConsultCountry: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var txtCountry: UITextField!
    
    //MARK: - Objects, Variables and Constants.
    
    ///Array for storing teams
    var teams: [Team] = [Team]()
    
    ///Countries.
    let countries: [AnyObject] = [
        ["country":
            [
                "name":"BOLIVIA",
                "value":"bolivia",
                "image":"bolivia"
            ]
        ],
        ["country":
            [
                "name":"CHILE",
                "value":"chile",
                "image":"chile"
            ]
        ],
        ["country":
            [
                "name":"COLOMBIA",
                "value":"colombia",
                "image":"colombia"
            ]
        ],
        ["country":
            [
                "name":"ECUADOR",
                "value":"ecuador",
                "image":"ecuador"
            ]
        ],
        ["country":
            [
                "name":"PERÚ",
                "value":"peru",
                "image":"peru"
            ]
        ],
        ["country":
            [
                "name":"VENEZUELA",
                "value":"venezuela",
                "image":"venezuela"
            ]
        ]
    ]
    
    ///Title of navigation bar.
    var navigationTitle: String = String()
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to search teams.
    @IBAction func search_teams(sender: UIButton) {
    
        guard self.validateFields() else {
            return
        }
        
        self.service_list_teams(self.txtCountry.text!.lowercaseString)
        
    }
    
    //MARK: - Functions: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard segue.identifier != NameSegues.segue_navigation_teams else {            
            
            let navigationControllerListTeams = segue.destinationViewController as! UINavigationController
            let controllerListTeams = navigationControllerListTeams.viewControllers.first as! ControllerListTeams
            controllerListTeams.teams = self.teams
            controllerListTeams.navigationItem.title = self.navigationTitle.uppercaseString
            
            return
            
        }
        
    }
    
    //MARK: - Methods: UITextFieldDelegate.
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard textField != self.txtCountry else {
            
            guard Functions.isLetter(string,range: range) == true else {
                return false
            }
            
            let newString: NSString = (self.txtCountry.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 50
            
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Functions: UITableViewDataSource.
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ControllerCustomCell = tableView.dequeueReusableCellWithIdentifier("cell") as! ControllerCustomCell
        cell.lblCountryName.text = String(self.countries[indexPath.row].objectForKey("country")!.objectForKey("name")!)
        cell.imgFlag.image = UIImage(named: String(self.countries[indexPath.row].objectForKey("country")!.objectForKey("image")!))
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.service_list_teams(String(self.countries[indexPath.row].objectForKey("country")!.objectForKey("value")!))
    }
    
    //MARK: - Functions: Self.
    
    /**
     Function to validate that the required fields are completed.
     - returns: Returns true if the fields are completed. Otherwise it returns false.
     */
    private func validateFields() -> Bool {
        
        guard self.txtCountry.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.txtCountry.becomeFirstResponder()
            
            return false
            
        }
        return true
        
    }
    
    //MARK: - Services.

    /**
     Service to list a country teams.
     - parameter country (String): Country to consult.
     */
    private func service_list_teams(country: String) {
    
        let data: Dictionary<String,AnyObject> = [
            "campeonato":country
        ]
        
        Functions.showWaitingMessage(self)
        
        Alamofire.request(Method.GET, APIServices.list_of_teams, parameters: data, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            Functions.dissmissWaitingMessage()
            
            guard response.result.isSuccess else {
                
                self.presentViewController(MessagesUIAlertController.informationMessage(MessageTypes.ERROR.rawValue, message: Messages.Global.INTERNAL_SERVER_ERROR), animated: true, completion: nil)
                
                return
                
            }
                        
            guard JSON(response.result.value!).array?.count > 0 else {
                
                self.presentViewController(MessagesUIAlertController.informationMessage(MessageTypes.WARNING.rawValue, message: Messages.ControllerListTeams.TEAMS_NOT_FOUND), animated: true, completion: nil)
                
                return
                
            }
            
            for index in 1...JSON(response.result.value!).array!.count {
                
                let team: Team = Team(json: JSON(response.result.value!).array![index-1])
                self.teams.append(team)
                
            }
            
            self.navigationTitle = country
            self.performSegueWithIdentifier(NameSegues.segue_navigation_teams, sender: nil)
            
        }
        
    }
    
}

