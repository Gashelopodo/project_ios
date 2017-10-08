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

class SetReview : NSObject{
    
    var review : Review?
    
    init(pReview : Review){
        self.review = pReview
        super.init()
    }
    
    func insert(_ callback: @escaping (Response?) -> ()){
        
        let response = Response(0, ERRORS.GENERAL, "")
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.VOTE
        var token = getToken()
        if token == nil{
            token = ""
        }
        
            
            let params: Parameters = [
                "review": (review?.params())!,
                "token": token
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
