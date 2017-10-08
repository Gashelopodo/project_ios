//
//  GetCircuits.swift
//  mxcircuit
//
//  Created by Mario alcazar on 26/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

class GetCircuit : NSObject{
    
    var userLocation: CLLocation
    var circuit_id : String
    
    init(_ userLocation : CLLocation, _ circuit_id : String){
        self.userLocation = userLocation
        self.circuit_id = circuit_id
        super.init()
    }
    
    func get(_ callback: @escaping (Circuit) -> ()){
        
        var reviews = [Review]()
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.GET_DATA_CIRCUIT
        var circuit_ = Circuit(pId: "", pName: "", pNameUrl: "", pDesc: "", pLogo: "", pPicture: "", pVideo: "", pData: "", pAddress: "", pCityId: "", pContactName: "", pContactEmail: "", pContactPhone: "", pHours: "", pPrice: "", pFacebook: "", pBar: "", pBathroom: "", pPhoto: "", pLavado: "", pCronos: "", pLat: "", pLng: "", pControl: "", pUdatedAt: "", pCreatedAt: "", pDistanceInKm: 0, pReview: reviews)
        
        let params: Parameters = [
            "circuit_id": circuit_id
        ]
        
        Alamofire.request(URL(string: urlData)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON(completionHandler: { (responseData) in
            
            
            if let valueData = responseData.result.value{
                let json = JSON(valueData)
                print(json)
                print(json["name"].string!)
                    reviews.removeAll()
                    for review in json["reviews"]{
                        reviews.append(
                            Review(pId: review.1["id"].string!,
                                   pRegisterId: review.1["id"].string!,
                                   pCircuitId: review.1["circuit_id"].string!,
                                   pInstallations: review.1["installations"].string!,
                                   pTerrain: review.1["terrain"].string!,
                                   pIrrigation: review.1["irrigation"].string!,
                                   pJumps: review.1["jumps"].string!,
                                   pSecurity: review.1["security"].string!,
                                   pCreatedAt: review.1["created_at"].string!)
                        )
                    }
                    
                    // calculamos distancia en kms del usuario a los circuitos
                    var latCircuit : Float = 0.0
                    var lngCircuit : Float = 0.0
                    
                    if let lat = json["lat"].string, let floatLat = Float(lat){
                        latCircuit = floatLat
                    }
                    
                    if let lng = json["lng"].string, let floatLng = Float(lng){
                        lngCircuit = floatLng
                    }
                    
                    let circuitLocation = CLLocation(latitude: CLLocationDegrees(latCircuit), longitude: CLLocationDegrees(lngCircuit))
                    let distance = getDistance(self.userLocation, circuitLocation)
                    
                    
                    circuit_ =
                        Circuit(pId: json["id"].string!,
                                pName: json["name"].string!,
                                pNameUrl: json["name_url"].string!,
                                pDesc: json["description"].string!,
                                pLogo: json["logo"].string!,
                                pPicture: json["picture"].string!,
                                pVideo: json["video"].string!,
                                pData: json["data"].string!,
                                pAddress: json["address"].string!,
                                pCityId: json["city_id"].string!,
                                pContactName: json["contact_name"].string!,
                                pContactEmail: json["contact_email"].string!,
                                pContactPhone: json["contact_phone"].string!,
                                pHours: json["hours"].string!,
                                pPrice: json["price"].string!,
                                pFacebook: json["facebook"].string!,
                                pBar: json["bar"].string!,
                                pBathroom: json["bathroom"].string!,
                                pPhoto: json["photo"].string!,
                                pLavado: json["lavado"].string!,
                                pCronos: json["cronos"].string!,
                                pLat: json["lat"].string!,
                                pLng: json["lng"].string!,
                                pControl: json["control"].string!,
                                pUdatedAt: json["updated_at"].string!,
                                pCreatedAt: json["created_at"].string!,
                                pDistanceInKm: distance,
                                pReview: reviews)
                    
                }
                
                callback(circuit_)
                
            
        })
        
    }
    
}
