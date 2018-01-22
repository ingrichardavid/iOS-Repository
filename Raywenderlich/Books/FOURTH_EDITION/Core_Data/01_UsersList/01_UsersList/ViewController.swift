//
//  ViewController.swift
//  01_UsersList
//
//  Created by Richard José David González on 19-01-18.
//  Copyright © 2018 Richard José David González. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //MARK: - Properties.
    
    private let nsManagedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var users: [NSManagedObject] = []
    
    //MARK: - @IBOutlets.
    
    @IBOutlet private weak var uiTableView: UITableView!
    
    //MARK: - @IBActions.
    
    @IBAction private func addUser(_ sender: UIBarButtonItem) {
        self.showAlertForAddUser()
    }
    
    @IBAction private func deleteUsers(_ sender: UIBarButtonItem) {
        self.removeUsers()
    }
    
    //MARK: - Functions: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users List"
        self.uiTableView.register(UITableViewCell.self,
                                  forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUsers()
    }

}

//MARK: - Functions: Self.

extension ViewController {
    
    private func showAlertForAddUser() {
        let uiAlertController = UIAlertController(title: "New User",
                                      message: "Add a new user",
                                      preferredStyle: .alert)
        let uiAlertActionSave = UIAlertAction(title: "Save",
                                              style: .default)
        { [unowned self] action in
            guard
                let uiTextFields = uiAlertController.textFields,
                let uiTextField = uiTextFields.first,
                let userName = uiTextField.text,
                !userName.isEmpty
            else {
                return
            }
            self.addUser(name: userName)
            self.uiTableView.reloadData()
        }
        let uiAlertActionCancel = UIAlertAction(title: "Cancel",
                                                style: .default)
        uiAlertController.addTextField()
        uiAlertController.addAction(uiAlertActionSave)
        uiAlertController.addAction(uiAlertActionCancel)
        self.present(uiAlertController,
                     animated: true)
    }
    
    private func getUsers() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        do {
            self.users = try self.nsManagedObjectContext.fetch(fetchRequest)
            self.uiTableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func addUser(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Users",
                                                in: self.nsManagedObjectContext)!
        let user = NSManagedObject(entity: entity,
                                   insertInto: self.nsManagedObjectContext)
        user.setValue(name, forKeyPath: "name")
        do {
            try self.nsManagedObjectContext.save()
            self.users.append(user)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func removeUsers() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        do {
            self.users = try self.nsManagedObjectContext.fetch(fetchRequest)
            guard self.users.count > 0 else {
                return
            }
            for user in users {
                self.nsManagedObjectContext.delete(user)
            }
            try self.nsManagedObjectContext.save()
            self.users.removeAll()
            self.uiTableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

//MARK: - Functions: UITableViewDataSource.

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        if let textLabel = cell.textLabel {
            let user = self.users[indexPath.row]
            textLabel.text = user.value(forKeyPath: "name") as? String
        }
        return cell
    }
    
}
