//
//  Errors.swift
//  mxcircuit
//
//  Created by Mario alcazar on 20/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation

let ERRORS = Errors();
let ALERTS = Alerts();


struct Errors {
    let EMPTY_REGISTER = "Los campos nombre y email son obligatorios."
    let GENERAL = "Ha ocurrido un problema."
    let HEADER_GENERAL = "Error"
}

struct Alerts {
    let SUCCESS = "Registro con éxito."
    let GENERAL = "Alerta"
}


