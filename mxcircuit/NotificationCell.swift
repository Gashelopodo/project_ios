//
//  NotificationCell.swift
//  mxcircuit
//
//  Created by Mario alcazar on 27/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // OUTLET
    @IBOutlet weak var titleCircuit: UILabel!
    @IBOutlet weak var descriptionNotification: UILabel!
    @IBOutlet weak var dateNotification: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
