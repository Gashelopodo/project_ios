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

class SetSetting : NSObject{
    
    var setting : Setting?
    var all : Int?
    
    init(setting : Setting, all : Int){
        self.setting = setting
        self.all = all
        super.init()
    }
    
    func update(_ callback: @escaping (Response?) -> ()){
        
        let response = Response(0, ERRORS.GENERAL, "")
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.SET_SETTING
        var token = getToken()
        if token == nil{
            token = ""
        }
        var params = Parameters()
        
        if all == 0{
            params = [
                "setting": (setting?.params())!
            ]
        }else{
            params = [
                "all": all!,
                "token": token
            ]
        }
        
        Alamofire.request(URL(string: urlData)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON(completionHandler: { (responseData) in
            switch responseData.result{
            case .success:
                
                if let valueData = responseData.result.value{
    
                    let json = JSON(valueData)
                    
                    response.code = json["code-error"].int
                    response.message = json["msg-error"].string!
                    
                }
                
            case .failure(let error):
                response.message = error.localizedDescription
            }
            
            callback(response)
            
        })
        
        
    }
    
}
