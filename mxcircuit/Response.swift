//
//  Response.swift
//  mxcircuit
//
//  Created by Mario alcazar on 20/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit


class Response: NSObject {
    
    var code : Int?
    var message : String?
    var data : Any?
    
    init(_ pCode : Int, _ pMessage : String, _ pData : Any) {
        self.code = pCode
        self.message = pMessage
        self.data = pData
        super.init()
    }
    
    
}

struct Response_{
    static let OK : Int = 1
    static let ERROR : Int = 0
}
    
