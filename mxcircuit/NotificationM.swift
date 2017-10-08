//
//  NotificationM.swift
//  mxcircuit
//
//  Created by Mario alcazar on 27/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit

class NotificationM: NSObject{
    
    var id : String?
    var name_circuit : String?
    var notification_id : String?
    var register_id : String?
    var circuit_id : String?
    var title : String?
    var desc : String?
    var send : String?
    var status : String?
    var message_status : String?
    var created_at : String?
    
    init(pId : String, pNameCircuit : String, pNotificationId : String, pRegisterId : String, pCircuitId : String, pTitle : String, pDesc : String, pSend : String, pStatus : String, pMessageStatus : String, pCreatedAt : String){
        self.id = pId
        self.name_circuit = pNameCircuit
        self.notification_id = pNotificationId
        self.register_id = pRegisterId
        self.circuit_id = pCircuitId
        self.title = pTitle
        self.desc = pDesc
        self.send = pSend
        self.status = pStatus
        self.message_status = pMessageStatus
        self.created_at = pCreatedAt
        super.init()
    }
    
}
