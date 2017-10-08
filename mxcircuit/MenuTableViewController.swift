//
//  MenuTableViewController.swift
//  mxcircuit
//
//  Created by Mario alcazar on 26/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    // OUTLET
    
    @IBOutlet weak var share: UITableViewCell!
    @IBOutlet weak var contact: UITableViewCell!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var emailUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shareApp))
        share.addGestureRecognizer(gesture)
        
        let gesture_ = UITapGestureRecognizer(target: self, action: #selector(contactApp))
        contact.addGestureRecognizer(gesture_)
        
        let register = getDataRegisterPref()
        if register != nil{
            nameUser.text = register.name
            emailUser.text = register.email
        }
        
    }
    
    func shareApp(){
        let url = NSURL(string: CONSTANTS.URLS.BASE)
        let shareItems : Array = [url]
        let activityVC:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func contactApp(){
        let email = CONSTANTS.URLS.EMAIL
        if let url = URL(string: "mailto:\(email)"){
            UIApplication.shared.open(url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ocultamos el navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier != nil{
            
            let web = self.storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController

            switch segue.identifier! {
                case "altacircuito":
                    web.urlweb = CONSTANTS.URLS.BASE+"circuitos/alta"
                case "comofuncionaapp":
                    web.urlweb = CONSTANTS.URLS.BASE+"dossier"
                case "accesoadmin":
                    web.urlweb = CONSTANTS.URLS.BASE+"admin/login"
                default:
                    print("nothing")
            }
        
            present(web, animated: true, completion: nil)
        
        }
        
    }

}
