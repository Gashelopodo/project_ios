//
//  GetWeather.swift
//  mxcircuit
//
//  Created by Mario alcazar on 2/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

class GetWeather : NSObject{
    
    var circuit: Circuit
    
    init(circuit : Circuit){
        self.circuit = circuit
        super.init()
    }
    
    func get(_ callback: @escaping ([Weather]) -> ()){
        
        var weathers = [Weather]()
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.GET_WEATHER
        
        let params: Parameters = [
            "circuit": circuit.params()
        ]
        
        Alamofire.request(URL(string: urlData)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON(completionHandler: { (responseData) in
            
            if let valueData = responseData.result.value{
                let json = JSON(valueData).dictionary!
                
                    weathers.append(
                        Weather(
                            pId: (json["id"]?.string!)!,
                            pCircuit_id: (json["circuit_id"]?.string!)!,
                            pWeather: (json["weather"]?.string!)!,
                            pUpdate_at: (json["update_at"]?.string!)!,
                            pCreated_at: (json["created_at"]?.string!)!
                        )
                    )
                
                
                callback(weathers)
                
            }
        })
        
    }
    
}

