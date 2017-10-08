//
//  GetSettings.swift
//  mxcircuit
//
//  Created by Mario alcazar on 10/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

class GetSettings : NSObject{
    
    var token: String
    
    init(token : String){
        self.token = token
        super.init()
    }
    
    func get(_ callback: @escaping ([Setting]) -> ()){
        
        var settings = [Setting]()
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.GET_SETTING
        
        let params: Parameters = [
            "token": token
        ]
        
        Alamofire.request(URL(string: urlData)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON(completionHandler: { (responseData) in
            
            if let valueData = responseData.result.value{
                let json = JSON(valueData)
                print(json)
                for setting in json {
                    
                    settings.append(
                        Setting(
                            pId: setting.1["id"].string!,
                            pRegisterId: setting.1["register_id"].string!,
                            pCircuitId: setting.1["circuit_id"].string!,
                            send: setting.1["send"].string!,
                            created_at: setting.1["created_at"].string!,
                            name_circuit: setting.1["name_circuit"].string!,
                            name_city: setting.1["name_city"].string!,
                            id_city: setting.1["id_city"].string!
                        )
                    )
                    
                }
                
                callback(settings)
                
            }
        })
        
    }
    
}
