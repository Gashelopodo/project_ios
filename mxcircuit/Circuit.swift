//
//  Circuit.swift
//  mxcircuit
//
//  Created by Mario alcazar on 26/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit

class Circuit: NSObject{

    var id : String?
    var name : String?
    var name_url : String?
    var desc: String?
    var logo : String?
    var picture : String?
    var video : String?
    var data : String?
    var address : String?
    var city_id : String?
    var contact_name : String?
    var contact_email : String?
    var contact_phone : String?
    var hours : String?
    var price : String?
    var facebook : String?
    var bar : String?
    var bathroom : String?
    var photo : String?
    var lavado : String?
    var cronos : String?
    var lat : String?
    var lng : String?
    var control : String?
    var updated_at : String?
    var created_at : String?
    var review : Array<Review>
    var distanceInKm : Float
    
    init(pId : String, pName : String, pNameUrl : String, pDesc : String, pLogo : String, pPicture : String, pVideo : String, pData : String, pAddress : String, pCityId : String, pContactName : String, pContactEmail : String, pContactPhone : String, pHours : String, pPrice : String, pFacebook : String, pBar : String, pBathroom : String, pPhoto : String, pLavado : String, pCronos : String, pLat : String, pLng : String, pControl : String, pUdatedAt : String, pCreatedAt : String, pDistanceInKm : Float, pReview : Array<Review>){
        
        self.id = pId
        self.name = pName
        self.name_url = pNameUrl
        self.desc = pDesc
        self.logo = pLogo
        self.picture = pPicture
        self.video = pVideo
        self.data = pData
        self.address = pAddress
        self.city_id = pCityId
        self.contact_name = pContactName
        self.contact_email = pContactEmail
        self.contact_phone = pContactPhone
        self.hours = pHours
        self.price = pPrice
        self.facebook = pFacebook
        self.bar = pBar
        self.bathroom = pBathroom
        self.photo = pPhoto
        self.lavado = pLavado
        self.cronos = pCronos
        self.lat = pLat
        self.lng = pLng
        self.control = pControl
        self.updated_at = pUdatedAt
        self.created_at = pCreatedAt
        self.distanceInKm = pDistanceInKm
        self.review = pReview
        super.init()
    }
    
    func params() -> Any{
        return [
            "id": id!,
            "name": name!,
            "language": "swift"
        ]
    }
    
    
}
