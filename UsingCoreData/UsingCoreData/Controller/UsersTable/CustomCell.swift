//
//  CustomCell.swift
//  UsingCoreData
//
//  Created by Ing. Richard José David González on 18/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    UITableViewCell implemented. This class provides an infrastructure to manage a custom cell.
*/
class CustomCell: UITableViewCell {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
        
}