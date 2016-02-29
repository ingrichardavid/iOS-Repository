//
//  TableViewCell.swift
//  InstagramClone
//
//  Created by Ing. Richard José David González on 11/2/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
 UITableViewCell implemented. This class provides an infrastructure to manage a custom cell.
 */
class TableViewCell: UITableViewCell {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var message: UILabel!
    
    //MARK: - Methods: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
