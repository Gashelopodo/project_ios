//
//  SetRreview.swift
//  mxcircuit
//
//  Created by Mario alcazar on 10/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CheckLogin : NSObject{
    
    var register : Register?
    
    init(register : Register){
        self.register = register
        super.init()
    }
    
    func check(_ callback: @escaping (Register?) -> ()){
        
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.CHECK_LOGIN
        print(register?.device_uuid)
        let params : Parameters = [
            "register": register?.params()
        ]
        
        Alamofire.request(URL(string: urlData)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON(completionHandler: { (responseData) in
            switch responseData.result{
            case .success:
                
                if let valueData = responseData.result.value{
                    
                    let json = JSON(valueData)
                    self.register = Register(
                        pId: json["id"].string!,
                        pName: json["name"].string!,
                        paEmail: json["email"].string!,
                        pDevice_uuid: json["device_uuid"].string!,
                        pDevice_model: json["device_model"].string!,
                        pDevice_cordova: json["device_cordova"].string!,
                        pDevice_platform: json["device_platform"].string!,
                        pDevice_version: json["device_version"].string!,
                        pDevice_serial: json["device_serial"].string!,
                        pDevice_token: json["device_token"].string!,
                        pControl: json["control"].string!,
                        pCreated_at: json["created_at"].string!
                    )
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            callback(self.register)
            
        })
        
        
    }
    
}
