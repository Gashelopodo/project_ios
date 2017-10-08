//
//  Weather.swift
//  mxcircuit
//
//  Created by Mario alcazar on 2/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit

class Weather: NSObject{
    
    var id : String?
    var circuit_id : String?
    var weather : String?
    var update_at : String?
    var created_at : String?
    
    init(pId : String, pCircuit_id : String, pWeather : String, pUpdate_at : String, pCreated_at : String){
        self.id = pId
        self.circuit_id = pCircuit_id
        self.weather = pWeather
        self.update_at = pUpdate_at
        self.created_at = pCreated_at
        super.init()
    }
    
}
