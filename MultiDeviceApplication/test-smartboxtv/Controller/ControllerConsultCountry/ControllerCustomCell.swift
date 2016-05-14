//
//  ControllerCustomCell.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 13/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit

/**
 Class to manage the cell structure of the UITableView. Implements UITableViewCell.
 */
class ControllerCustomCell: UITableViewCell {
    
    //MARK: - Connecting elements storyboard: IBOutlet.

    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    
    //MARK: - Functions: UITableViewCell.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
