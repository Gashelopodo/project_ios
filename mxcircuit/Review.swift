//
//  Review.swift
//  mxcircuit
//
//  Created by Mario alcazar on 26/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit

class Review: NSObject{
    
    var id : String?
    var register_id : String?
    var circuit_id : String?
    var installations : String?
    var terrain : String?
    var irrigation : String?
    var jumps : String?
    var security : String?
    var created_at : String?
    static let CATEGORIES : [String] = [ "installation", "terrain", "irrigation", "jumps", "security" ]
    static let TOTAL_STARS : Int = 5
    
    init(pId : String, pRegisterId : String, pCircuitId : String, pInstallations : String, pTerrain : String, pIrrigation : String, pJumps : String, pSecurity : String, pCreatedAt : String){
        self.id = pId
        self.register_id = pRegisterId
        self.circuit_id = pCircuitId
        self.installations = pInstallations
        self.terrain = pTerrain
        self.irrigation = pIrrigation
        self.jumps = pJumps
        self.security = pSecurity
        self.created_at = pCreatedAt
        super.init()
    }
    
    func params() -> Any{
        return [
            "circuit_id": circuit_id!,
            "installations": installations!,
            "terrain": terrain!,
            "irrigation": irrigation!,
            "jumps": jumps!,
            "security": security!,
            "language": "swift"
        ]
    }
    

}
