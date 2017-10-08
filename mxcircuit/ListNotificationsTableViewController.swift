//
//  ListNotificationsTableViewController.swift
//  mxcircuit
//
//  Created by Mario alcazar on 27/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit

class ListNotificationsTableViewController: UITableViewController {
    
    // VARS
    var notifications = [NotificationM]()
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.backBarButtonItem?.title = "< Volver"
        
        // check network
        guard let status = Network.reachability?.status else { return }
        if status == .unreachable{
            print("No hay internet")
            present(showAlert("Hay un problema", messageData: "No dispone de conexión a internet."), animated: true, completion: nil)
        }
        
        // load indicator
        loadIndicator()
        
        // seteamos atributos a la tableview
        setAtributtesTable()
        
        // obtenemos listado de notiticaciones
        httpGetNotifications()
        
    }
    
    func httpGetNotifications(){
        let getNotifications = GetNotifications(token: getToken())
        getNotifications.get { (notifications) in
            self.notifications = notifications
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    func loadIndicator(){
        let size = 50
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = CGPoint(x: Int((Float(UIScreen.main.bounds.width)/2)), y: 120)
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        
    }
    
    func setAtributtesTable(){
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.backgroundColor = UIColor.white
        tableView.sectionHeaderHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
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
        return notifications.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row]
        
        notificationCell.titleCircuit.text = notification.name_circuit
        notificationCell.descriptionNotification.text = notification.desc
        notificationCell.dateNotification.text = convertDate(notification.created_at!)
        
        return notificationCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        if notification.circuit_id != "55"{
            performSegue(withIdentifier: "showProfileDesdeNotification", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileDesdeNotification"{
            let profileCircuit = segue.destination as! ProfileCircuitTableViewController
            let row = tableView.indexPathForSelectedRow?.row
            let notification = notifications[row!]
            profileCircuit.idCircuit = notification.circuit_id!
            
        }
    }
    
    


}
