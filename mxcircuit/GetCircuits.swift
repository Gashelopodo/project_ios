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

class GetCircuits : NSObject{
    
    var userLocation: CLLocation
    
    init(_ userLocation : CLLocation){
        self.userLocation = userLocation
        super.init()
    }
    
    func get(_ callback: @escaping (Array<Circuit>) -> ()){
        
        var circuits = [Circuit]()
        var reviews = [Review]()
        let urlData = CONSTANTS.URLS.BASE + CONSTANTS.URLS.API + CONSTANTS.URLS.GET_CIRCUITS
        
        Alamofire.request(URL(string: urlData)!, method: .get).validate().responseJSON(completionHandler: { (responseData) in
            
            if let valueData = responseData.result.value{
                let json = JSON(valueData)
                for circuit in json {
                    
                    reviews.removeAll()
                    for review in circuit.1["reviews"]{
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
                    
                    if let lat = circuit.1["lat"].string, let floatLat = Float(lat){
                        latCircuit = floatLat
                    }
                    
                    if let lng = circuit.1["lng"].string, let floatLng = Float(lng){
                        lngCircuit = floatLng
                    }
                    
                    let circuitLocation = CLLocation(latitude: CLLocationDegrees(latCircuit), longitude: CLLocationDegrees(lngCircuit))
                    let distance = getDistance(self.userLocation, circuitLocation)
                    
                    
                    circuits.append(
                        Circuit(pId: circuit.1["id"].string!,
                                pName: circuit.1["name"].string!,
                                pNameUrl: circuit.1["name_url"].string!,
                                pDesc: circuit.1["description"].string!,
                                pLogo: circuit.1["logo"].string!,
                                pPicture: circuit.1["picture"].string!,
                                pVideo: circuit.1["video"].string!,
                                pData: circuit.1["data"].string!,
                                pAddress: circuit.1["address"].string!,
                                pCityId: circuit.1["city_id"].string!,
                                pContactName: circuit.1["contact_name"].string!,
                                pContactEmail: circuit.1["contact_email"].string!,
                                pContactPhone: circuit.1["contact_phone"].string!,
                                pHours: circuit.1["hours"].string!,
                                pPrice: circuit.1["price"].string!,
                                pFacebook: circuit.1["facebook"].string!,
                                pBar: circuit.1["bar"].string!,
                                pBathroom: circuit.1["bathroom"].string!,
                                pPhoto: circuit.1["photo"].string!,
                                pLavado: circuit.1["lavado"].string!,
                                pCronos: circuit.1["cronos"].string!,
                                pLat: circuit.1["lat"].string!,
                                pLng: circuit.1["lng"].string!,
                                pControl: circuit.1["control"].string!,
                                pUdatedAt: circuit.1["updated_at"].string!,
                                pCreatedAt: circuit.1["created_at"].string!,
                                pDistanceInKm: distance,
                                pReview: reviews)
                    )
                 }
                
                callback(circuits)
                
            }
        })
        
    }
    
}
