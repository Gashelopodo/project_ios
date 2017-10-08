//
//  Setting.swift
//  mxcircuit
//
//  Created by Mario alcazar on 10/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit

class Setting: NSObject{
    
    var id : String?
    var register_id : String?
    var circuit_id : String?
    var send : String?
    var created_at : String?
    var name_circuit : String?
    var name_city : String?
    var id_city : String?
    var control : Bool?
    
    init(pId : String, pRegisterId : String, pCircuitId : String, send : String, created_at : String, name_circuit : String, name_city : String, id_city : String){
        self.id = pId
        self.register_id = pRegisterId
        self.circuit_id = pCircuitId
        self.send = send
        self.created_at = created_at
        self.name_circuit = name_circuit
        self.name_city = name_city
        self.id_city = id_city
        self.control = false
        super.init()
    }
    
    func params() -> Any{
        return [
            "id": id!,
            "register_id": register_id!,
            "circuit_id": circuit_id!,
            "send": send!,
            "created_at": created_at!,
            "name_circuit": name_circuit!,
            "id_city": id_city!,
            "control": control!,
            "language": "swift"
        ]
    }
    
}
