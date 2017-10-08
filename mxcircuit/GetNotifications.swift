//
//  GetNotifications.swift
//  mxcircuit
//
//  Created by Mario alcazar on 27/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

class GetNotifications : NSObject{
    
    var token: String
    
    init(token : String){
        self.token = token
        super.init()
    }
    
    func get(_ callback: @escaping ([NotificationM]) -> ()){
        
        var notifications = [NotificationM]()
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.GET_NOTIFICATIONS
        
        let params: Parameters = [
            "token": token
        ]
        
        Alamofire.request(URL(string: urlData)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON(completionHandler: { (responseData) in
            
            if let valueData = responseData.result.value{
                let json = JSON(valueData)
                for notification in json {
                    
                    notifications.append(
                        NotificationM(
                            pId: notification.1["id"].string!,
                            pNameCircuit: notification.1["name_circuit"].string!,
                            pNotificationId: notification.1["notification_id"].string!,
                            pRegisterId: notification.1["register_id"].string!,
                            pCircuitId: notification.1["circuit_id"].string!,
                            pTitle: notification.1["title"].string!,
                            pDesc: notification.1["description"].string!,
                            pSend: notification.1["send"].string!,
                            pStatus: notification.1["status"].string!,
                            pMessageStatus: notification.1["message_status"].string!,
                            pCreatedAt: notification.1["created_at"].string!
                        )
                    )
                }
                
                callback(notifications)
                
            }
        })
        
    }
    
}

