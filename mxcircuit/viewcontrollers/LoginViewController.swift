//
//  LoginViewController.swift
//  mxcircuit
//
//  Created by Mario alcazar on 20/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit
import DeviceKit

class LoginViewController: UIViewController {
    
    
    // VARS
    let device = Device()
    
    //OUTLET
    
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var emailUser: UITextField!
    
    //ACTION
    
    @IBAction func goLogin(_ sender: UIButton) {
        
        let name = nameUser.text
        let email = emailUser.text
        var token : String = getToken()
        
        if token == nil{
            token = ""
        }
        
        let register = Register(pId: "", pName: name!, paEmail: email!, pDevice_uuid: (UIDevice.current.identifierForVendor?.uuidString)!, pDevice_model: device.description, pDevice_cordova: "", pDevice_platform: "iOS", pDevice_version: device.systemVersion, pDevice_serial: "", pDevice_token: token, pControl: "", pCreated_at: "")
        
        // registramos usuario nuevo
        let setRegister = SetRegister(pRegister: register)
        setRegister.goRegister { (response) in
            if response?.code == 0 {
                self.present(showAlert(ALERTS.GENERAL, messageData: (response?.message)!), animated: true, completion: nil)
            }else{
                register.id = String(describing: (response?.data)!)
                setLoginPref(register: register)
                self.goListCircuit()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ocultamos el navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // vemos si ya hemos iniciado sesión
        isLogin()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard dissmiss
        self.hideKeyboardWhenTappedAround()
        
        paddingInput(nameUser)
        paddingInput(emailUser)
        
    }
    
    func isLogin(){
        let register = getDataRegisterPref()
        let login = getLoginPref()
        if register.id != "" && login {
            print("Estamos logueados -> nos vamos a listado de circuitos")
            goListCircuit()
            
        }else{
            // comprobamos que el dispositivo ya esté registrado
            let register = Register(pId: "0", pName: "", paEmail: "", pDevice_uuid: (UIDevice.current.identifierForVendor?.uuidString)!, pDevice_model: "", pDevice_cordova: "", pDevice_platform: "", pDevice_version: "", pDevice_serial: "", pDevice_token: "", pControl: "", pCreated_at: "")
            let checkLogin = CheckLogin(register: register)
            checkLogin.check { (register) in
                if register != nil && register?.id != "0"{
                    setLoginPref(register: register!)
                    self.goListCircuit()
                }
            }
        }
    }
    
    
    func goListCircuit(){
        let ListCircuitVC = self.storyboard?.instantiateViewController(withIdentifier: "ListCircuitTableViewController") as! ListCircuitTableViewController
        self.navigationController?.pushViewController(ListCircuitVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}












