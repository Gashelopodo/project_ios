//
//  SetRegister.swift
//  mxcircuit
//
//  Created by Mario alcazar on 20/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SetRegister : NSObject{
    
    var register : Register?
    
    init(pRegister : Register){
        self.register = pRegister
        super.init()
    }
    
    func goRegister(_ callback: @escaping (Response?) -> ()){
        
        let response = Response(0, ERRORS.GENERAL, "")
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.REGISTER_USER
        
        if !(register?.name?.isEmpty)! && !(register?.email?.isEmpty)!{
            
            let params: Parameters = [
                "data": (register?.params())!
            ]
            
            Alamofire.request(URL(string: urlData)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON(completionHandler: { (responseData) in
                switch responseData.result{
                    case .success:
                        
                        if let valueData = responseData.result.value{
                            let json = JSON(valueData)
                            response.data = json["id-insert"]
                            response.code = json["code-error"].int
                            
                            if response.code == 1{
                                response.message = ALERTS.SUCCESS
                            }else{
                                response.message = json["msg-error"].string!
                            }
                            
                        }
                    
                    case .failure(let error):
                        response.message = error.localizedDescription
                }
    
                callback(response)
                
            })
            
        }else{
            response.message = ERRORS.EMPTY_REGISTER
            callback(response)
        }
        
    }
    
}


