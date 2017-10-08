//
//  SettingTableViewController.swift
//  mxcircuit
//
//  Created by Mario alcazar on 10/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit
import DeviceKit

class SettingTableViewController: UITableViewController {
    
    //VARS
    
    var settings = [Setting]()
    var lastCity : String = ""
    var lastCity_ : String = ""
    var indexCity = [Int]()
    var labelCity = UILabel()
    var device = Device()
    
    // OUTLET
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var emailUser: UILabel!
    
    
    
    //ACTION
    @IBAction func allSwitch(_ sender: UISwitch) {
        
        var send = 2
        
        if sender.isOn{
            send = 1
        }
        
        for setting in settings {
            setting.send = String(send)
        }
        
        let setSetting = SetSetting(setting: Setting(pId: "", pRegisterId: "", pCircuitId: "", send: "", created_at: "", name_circuit: "", name_city: "", id_city: ""), all: send)
        setSetting.update { (response) in
            
            print(response?.message!)

        }
        
        self.tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check network
        guard let status = Network.reachability?.status else { return }
        if status == .unreachable{
            print("No hay internet")
            present(showAlert("Hay un problema", messageData: "No dispone de conexión a internet."), animated: true, completion: nil)
        }
        
        tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        tableView.register(UINib(nibName: "SettingSinTitleCell", bundle: nil), forCellReuseIdentifier: "SettingSinTitleCell")
        
        var token = getToken()
        if token == nil{
            token = ""
        }
        
        // load settings
        let getSettings = GetSettings(token: token)
        getSettings.get { (settings) in
            self.settings = settings
            var lastCity = ""
            var i = 0
            for setting in settings{
                if setting.name_city! != lastCity{
                    lastCity = setting.name_city!
                    self.indexCity.append(i)
                }
                i+=1
            }
            print(self.indexCity)
            self.tableView.reloadData()
        }
        
        // get data
        let register = getDataRegisterPref()
        if register != nil{
            nameUser.text = "Nombre: "+register.name!
            emailUser.text = "Email: "+register.email!
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // mostramos de nuevo el navigation bar y propiedades
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setAtributtesNavigationBar(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let setting = settings[indexPath.row]
        
        if indexCity.contains(indexPath.row) {
            
            lastCity = setting.name_city!

             let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
             settingCell.setting = setting
             settingCell.city.text = setting.name_city
             settingCell.name.text = setting.name_circuit
             settingCell.switch_.isOn = (Int(setting.send!)! == 1) ? true : false
            
             return settingCell
            
        }else{
            
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingSinTitleCell", for: indexPath) as! SettingSinTitleCell
            settingCell.setting = setting
            settingCell.name.text = setting.name_circuit
            settingCell.switch_.isOn = (Int(setting.send!)! == 1) ? true : false

            return settingCell
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexCity.contains(indexPath.row) {
            return 84
        }else{
            return 40
        }
        
    }
    

    
}

