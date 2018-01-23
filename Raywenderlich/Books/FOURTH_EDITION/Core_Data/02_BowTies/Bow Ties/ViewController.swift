/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class ViewController: UIViewController {

  // MARK: - Properties.
  
  var managedContext: NSManagedObjectContext!
  private var currentBowtie: Bowtie!
  
  // MARK: - IBOutlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.insertSampleData()
    
    let firsTitle = self.segmentedControl.titleForSegment(at: 0)!

    let request: NSFetchRequest<Bowtie> = Bowtie.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Bowtie.searchKey), firsTitle])
    
    do {
      let results = try self.managedContext.fetch(request)
      self.currentBowtie = results.first
      
      self.populate(bowtie: results.first!)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }

  // MARK: - IBActions
  @IBAction func segmentedControl(_ sender: Any) {
    guard
      let control =  sender as? UISegmentedControl,
      let selectedValue = control.titleForSegment(at: control.selectedSegmentIndex) else
    {
      return
    }
    
    let request = NSFetchRequest<Bowtie>(entityName: "Bowtie")
    request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Bowtie.searchKey), selectedValue])
    
    do {
      let results =  try self.managedContext.fetch(request)
      self.currentBowtie =  results.first
      self.populate(bowtie: self.currentBowtie)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }

  @IBAction private func wear(_ sender: Any) {
    let times = self.currentBowtie.timesWorn
    self.currentBowtie.timesWorn = times + 1
    self.currentBowtie.lastWorn = NSDate()
    
    do {
      try self.managedContext.save()
      self.populate(bowtie: self.currentBowtie)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  @IBAction private func rate(_ sender: Any) {
    let alert = UIAlertController(title: "New Rating",
                                  message: "Rate this bow tie",
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.keyboardType = .decimalPad
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default)
    { [unowned self] action in
      guard let textField = alert.textFields?.first else {
        return
      }
      self.update(rating: textField.text)
    }
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    self.present(alert, animated: true)
  }

}

// MARK: - Functions: Self.

extension ViewController {
  
  func insertSampleData() {
    let fetch: NSFetchRequest<Bowtie> = Bowtie.fetchRequest()
    fetch.predicate = NSPredicate(format: "searchKey != nil")

    let count = try! self.managedContext.count(for: fetch)
    if count > 0 {
      return
    }
    
    let path = Bundle.main.path(forResource: "SampleData",
                                ofType: "plist")
    let dataArray = NSArray(contentsOfFile: path!)!
    
    for dict in dataArray {
      let entity = NSEntityDescription.entity(
        forEntityName: "Bowtie",
        in: self.managedContext)!
    
      let bowtie = Bowtie(entity: entity,
                          insertInto: self.managedContext)
      
      let btDict = dict as! [String: Any]
      bowtie.id = UUID(uuidString: btDict["id"] as! String)
      bowtie.name = btDict["name"] as? String
      bowtie.searchKey = btDict["searchKey"] as? String
      bowtie.rating = btDict["rating"] as! Double
      
      let colorDict = btDict["tintColor"] as! [String: Any]
      bowtie.tintColor = UIColor.color(dict: colorDict)
      
      let imageName = btDict["imageName"] as? String
      
      let image = UIImage(named: imageName!)
      
      let photoData = UIImagePNGRepresentation(image!)!
      bowtie.photoData = NSData(data: photoData)
      bowtie.lastWorn = btDict["lastWorn"] as? NSDate
      
      let timesNumber = btDict["timesWorn"] as! NSNumber
      bowtie.timesWorn = timesNumber.int32Value
      bowtie.isFavorite = btDict["isFavorite"] as! Bool
      bowtie.url = URL(string: btDict["url"] as! String)
    }
    
    try! self.managedContext.save()
  }
  
  func populate(bowtie: Bowtie) {
    guard
      let imageData = bowtie.photoData as Data?,
      let lastWorn = bowtie.lastWorn as Date?,
      let tintColor = bowtie.tintColor as? UIColor else {
        return
    }
    
    self.imageView.image = UIImage(data: imageData)
    self.nameLabel.text = bowtie.name
    self.ratingLabel.text = "Rating: \(bowtie.rating)/5"
    self.timesWornLabel.text = "# times worn: \(bowtie.timesWorn)"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    
    self.lastWornLabel.text = "Last worn: " + dateFormatter.string(from: lastWorn)
    self.favoriteLabel.isHidden = !bowtie.isFavorite
    
    self.view.tintColor = tintColor
  }
  
  func update(rating: String?) {
    guard
      let ratingString = rating,
      let rating = Double(ratingString) else
    {
        return
    }
    do {
      self.currentBowtie.rating = rating
      try self.managedContext.save()
      self.populate(bowtie: self.currentBowtie)
    } catch let error as NSError {
      if error.domain == NSCocoaErrorDomain &&
        (error.code == NSValidationNumberTooLargeError ||
          error.code == NSValidationNumberTooSmallError) {
        self.rate(self.currentBowtie)
      } else {
        print("Could not save \(error), \(error.userInfo)")
      }
    }
  }
  
}

// MARK: - Functions: UIColor.

private extension UIColor {
  
  static func color(dict: [String : Any]) -> UIColor? {
    guard
      let red = dict["red"] as? NSNumber,
      let green = dict["green"] as? NSNumber,
      let blue = dict["blue"] as? NSNumber else {
        return nil
    }
    return UIColor(red: CGFloat(truncating: red) / 255.0,
                   green: CGFloat(truncating: green) / 255.0,
                   blue: CGFloat(truncating: blue) / 255.0,
                   alpha: 1)
  }
  
}
