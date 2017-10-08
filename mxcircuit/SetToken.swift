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

class SetToken : NSObject{
    
    var lastToken : String?
    var newToken : String?
    var uuid : String?
    
    init(lastToken : String, newToken : String, uuid : String){
        self.lastToken = lastToken
        self.newToken = newToken
        self.uuid = uuid
        super.init()
    }
    
    func update(_ callback: @escaping (Response?) -> ()){
        
        let response = Response(0, ERRORS.GENERAL, "")
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.SET_TOKEN
        
        let params : Parameters = [
            "lastToken": lastToken!,
            "newToken": newToken!,
            "uuid": uuid!
        ]
        
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
