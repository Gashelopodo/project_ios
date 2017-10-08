//
//  SettingSinTitleCell.swift
//  mxcircuit
//
//  Created by Mario alcazar on 27/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit

class SettingSinTitleCell: UITableViewCell {
    
    // VARS
    var setting : Setting?
    
    // ACTION
    @IBAction func goSwitch(_ sender: UISwitch) {
        
        var send = 2
        
        if sender.isOn{
            send = 1
        }
        
        setting?.send = String(send)
        
        var setSetting = SetSetting(setting: setting!, all: 0)
        setSetting.update { (response) in
            
            print(response?.message!)
            
        }
        
    }
    
    //OUtlet
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var switch_: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
