//
//  Prefs.swift
//  mxcircuit
//
//  Created by Mario alcazar on 21/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import DeviceKit

// userdefaults

let customPrefs = UserDefaults.standard
let device = Device()

// structs

let PREFS = Prefs()

struct Prefs {
    let LOGIN = "login"
    let LOGIN_DATA = "logindata"
    let TOKEN = "token"
    let CIRCUIT_ID = "circuit_id"
}

// funciones prefs

func setLoginPref(register: Register){
    customPrefs.set(true, forKey: PREFS.LOGIN)
    let json = JSON(register.params())
    if let string = json.rawString() {
        customPrefs.set(string, forKey: PREFS.LOGIN_DATA)
    }
    
}

func setToken(_ token: String){
    customPrefs.set(token, forKey: PREFS.TOKEN)
}

func getToken() -> String{
    if device.isSimulator{
        customPrefs.set("8389202022929292", forKey: PREFS.TOKEN)
    }
    return customPrefs.string(forKey: PREFS.TOKEN)!
}

func setIdCircuitNotification(_ circuit_id : String){
    customPrefs.set(circuit_id, forKey: PREFS.CIRCUIT_ID)
}

func getIdCircuitNotification() -> String{
    return customPrefs.string(forKey: PREFS.CIRCUIT_ID)!
}

func getLoginPref() -> Bool{
    return customPrefs.bool(forKey: PREFS.LOGIN)
}

func getDataRegisterPref() -> Register{
    
    var register = Register(pId: "", pName: "", paEmail: "", pDevice_uuid: "", pDevice_model: "", pDevice_cordova: "", pDevice_platform: "", pDevice_version: "", pDevice_serial: "", pDevice_token: "", pControl: "", pCreated_at: "")
    
    let data = customPrefs.string(forKey: PREFS.LOGIN_DATA)
    
    if(data != nil){
        if let dataFromString = data!.data(using: .utf8, allowLossyConversion: false){
            let json = JSON(dataFromString)
            register.id = json["id"].string
            register.name = json["name"].string
            register.email = json["email"].string
            register.device_uuid = json["device_uuid"].string
            register.device_token = json["device_token"].string
        }
    
    }
    
    return register
}
