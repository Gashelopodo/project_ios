//
//  Utils.swift
//  mxcircuit
//
//  Created by Mario alcazar on 20/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MapKit
import CoreLocation

// constantes y estructuras

let CONSTANTS = Constants();

struct Constants {
    let COLORS = Colors()
    let URLS = Urls()
    let UTILS = Utils()
}

struct Colors {
    let RED = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
}

struct Urls {
    let BASE = "http://www.mxcircuit.es/"
    let API = "admin/api/"
    let REGISTER_USER = "registerTESTER"
    let GET_CIRCUITS = "getListv2"
    let GET_DATA_CIRCUIT = "getDataCircuitv2"
    let GET_NOTIFICATIONS = "getNotificationsUser"
    let GET_NOTIFICATIONS_TO_CIRCUIT = "getNotificationsUserToCircuit"
    let GET_WEATHER = "getWeather"
    let CHECK_LOGIN = "userExistv2"
    let VOTE = "votev2"
    let SET_SETTING = "setSetting"
    let SET_TOKEN = "setTokenV2"
    let GET_SETTING = "getSetting"
    let EMAIL = "info@mxcircuit.es"
}

struct Utils {
    let SHORT = 1
    let LONG = 2
}

// funciones

public func paddingInput(_ text: UITextField) -> Void{
    text.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
}

func showAlert(_ titleData : String, messageData : String)-> UIAlertController{
    let alertVC = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alertVC
}

func setAtributtesNavigationBar(_ view : UIViewController){
    
    // escondemos el botón atrás
    if view is ListCircuitTableViewController {
        view.navigationItem.setHidesBackButton(true, animated: true)
    }else{
        view.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // pintamos logo
    let height = view.navigationController?.navigationBar.frame.height
    let image = UIImage(named: "logo")
    
    let heightImage = height! * 0.5
    let widthImage = ((image?.size.width)! * heightImage) / (image?.size.height)!
    
    let scaleImage = resizeImage(image!, Int(widthImage), Int(heightImage))
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: widthImage, height: heightImage))
    imageView.contentMode = .scaleAspectFit
    
    imageView.image = scaleImage
    view.navigationItem.titleView = imageView

}

func resizeImage(_ image: UIImage, _ width : Int, _ height : Int) -> UIImage{
    var scaleImage = UIImage()
    UIGraphicsBeginImageContext(CGSize(width: width, height: height))
    image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
    
    scaleImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return scaleImage
}

func isString
    (_ json : JSON, _ nombre : String) -> String{
    if let stringResult = json[nombre].string
    {
        return stringResult
    }else{
        return ""
    }
}

func getDistance(_ userLocation : CLLocation, _ circuitLocation : CLLocation) -> Float{
    let distanceInMeters = userLocation.distance(from: circuitLocation)
    return Float(distanceInMeters/1000)
}

func getImageUrl(_ stringUrl : String) -> NSData{
    var imageData = NSData()
    if let url = NSURL(string: stringUrl){
        if let data = NSData(contentsOf: url as URL){
            imageData = data
        }
    }
    return imageData
}

func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
    
}

func toCentigrados(_ far : Double) -> Int{
    return (Int((far-32)/1.8000));
}

func translateDay(_ dayValue: String, _ type: Int) -> String{
    
    var translateDay: String = "";
    let days: [String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    let daysT: [String] = ["Lunes","Martes","Miércoles","Jueves","Viernes","Sábado","Domingo"];
    var pos: Int = 0;
    var i = 0
    for day in days {
        if(day == dayValue){
            pos = i;
        }
        i += 1
    }
    
    switch type {
    case CONSTANTS.UTILS.SHORT:
        let index = daysT[pos].index(daysT[pos].startIndex, offsetBy: 3)
        translateDay = daysT[pos].substring(to: index)
    case CONSTANTS.UTILS.LONG:
        translateDay = daysT[pos]
    default: break
    }
    
    return translateDay;
}

func getLabelsInView(_ view: UIView) -> [UILabel] {
    var results = [UILabel]()
    for subview in view.subviews as [UIView] {
        if let labelView = subview as? UILabel {
            results += [labelView]
        } else {
            results += getLabelsInView(subview)
        }
    }
    return results
}

func checkToken(_ token: String){
    let register = getDataRegisterPref()
    if register != nil{
        if token != register.device_token && register.device_uuid != ""{
            print("El token es diferente. Lo cambiamos")
            let setToken = SetToken(lastToken: register.device_token!, newToken: token, uuid: register.device_uuid!)
            setToken.update({ (response) in
                print(response?.message)
            })
        }
    }
}

func convertDate(_ date: String) -> String{
    
    var newDate = ""
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateTime = formatter.date(from: date)
    let timeNotification = (dateTime?.timeIntervalSince1970)!
    
    let currentDateTime = Date()
    let timeNow = currentDateTime.timeIntervalSince1970
    
    var seconds = timeNow - timeNotification
    var minutes = seconds/60
    var hours = minutes/60
    var days =  hours/24
    
    
    if days < 1{
        if hours < 1{
            if minutes < 1{
                seconds = seconds.rounded(.down)
                if seconds > 1{
                    newDate = "hace \(Int(seconds)) segundos"
                }else{
                    newDate = "hace \(Int(seconds)) segundo"
                }
            }else{
                minutes = minutes.rounded(.down)
                if minutes > 1{
                    newDate = "hace \(Int(minutes)) minutos"
                }else{
                    newDate = "hace \(Int(minutes)) minuto"
                }
            }
        }else{
            hours = hours.rounded(.down)
            if hours > 1{
                newDate = "hace \(Int(hours)) horas"
            }else{
                newDate = "hace \(Int(hours)) hora"
            }
        }
    }else{
        days = days.rounded(.down)
        if days > 1{
            newDate = "hace \(Int(days)) días"
        }else{
            newDate = "hace \(Int(days)) día"
        }
    }
    
    return newDate
    
}













