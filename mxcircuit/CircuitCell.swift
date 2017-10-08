//
//  CircuitCell.swift
//  mxcircuit
//
//  Created by Mario alcazar on 22/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit

class CircuitCell: UITableViewCell {
    
    // OUTLET
    @IBOutlet weak var nameCircuit: UILabel!
    @IBOutlet weak var kmsCircuit: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
