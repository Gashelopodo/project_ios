//
//  Register.swift
//  mxcircuit
//
//  Created by Mario alcazar on 20/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit


class Register: NSObject {
    
    var id : String?
    var name : String?
    var email : String?
    var device_uuid : String?
    var device_model : String?
    var device_cordova : String?
    var device_platform : String?
    var device_version : String?
    var device_serial : String?
    var device_token : String?
    var control : String?
    var created_at : String?
    
    init(pId : String, pName : String, paEmail : String, pDevice_uuid : String, pDevice_model : String, pDevice_cordova : String, pDevice_platform : String, pDevice_version : String, pDevice_serial : String, pDevice_token : String, pControl : String, pCreated_at : String) {
        self.id = pId
        self.name = pName
        self.email = paEmail
        self.device_uuid = pDevice_uuid
        self.device_model = pDevice_model
        self.device_cordova = pDevice_cordova
        self.device_platform = pDevice_platform
        self.device_version = pDevice_version
        self.device_serial = pDevice_serial
        self.device_token = pDevice_token
        self.control = pControl
        self.created_at = pCreated_at
        super.init()
    }
    
    func params() -> Any{
        return [
            "id": id!,
            "name": name!,
            "email": email!,
            "device_uuid": device_uuid!,
            "device_platform": device_platform!,
            "device_token": device_token!,
            "device_model": device_model!,
            "device_version": device_version!,
            "language": "swift"
        ]
    }
    
    
}
