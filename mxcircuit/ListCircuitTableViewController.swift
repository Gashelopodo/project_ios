//
//  ListCircuitTableViewController.swift
//  mxcircuit
//
//  Created by Mario alcazar on 25/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit
import MapKit
import SideMenu
import DeviceKit

class ListCircuitTableViewController: UITableViewController {
    
    // OUTLET
    @IBOutlet weak var labelheader: UILabel!
    
    // VARS
    var circuits = [Circuit]()
    var indicator = UIActivityIndicatorView()
    var locationManager = CLLocationManager()
    let device = Device()
    let groupDevices: [Device] = [.iPhone5, .iPhone5s, .iPhone6, .iPhone6s, .iPhone6sPlus, .iPhone6Plus]
    let groupDevicesSimulator: [Device] = [.simulator(.iPhone5), .simulator(.iPhone5s), .simulator(.iPhone6), .simulator(.iPhone6s), .simulator(.iPhone6sPlus), .simulator(.iPhone6Plus)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                locationDisabled()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            default:
                locationDisabled()
            }
            
        }
        
    }
    
    func locationDisabled(){
        
        print("ENTRO EN LOCATION DISABLED")
        
        let alertController = UIAlertController (title: "Hay un problema", message: "No se puede acceder a la geolocalización de tu disposivo. Para un correcto funcionamiento de la aplicación necesitamos disponer de su localización para ofrecerle el listado de circuitos según su posición. Active la localización de su dispositivo y reintente.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Ajustes", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func getCircuitsHttp(_ userLocation : CLLocation){
        // traemos listado de circuitos
        let getCircuits = GetCircuits(userLocation)
        getCircuits.get { (circuits) in
            // ordenamos por distancia
            let circuitSort = circuits.sorted(by: { (this:Circuit, that:Circuit) -> Bool in
                return this.distanceInKm < that.distanceInKm
            })
            self.circuits = circuitSort
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    func loadIndicator(){
        let size = 50
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        indicator.center = CGPoint(x: Int((Float(UIScreen.main.bounds.width)/2)), y: 120)
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        
    }
    
    func setAtributtesTable(){
        tableView.register(UINib(nibName: "CircuitCell", bundle: nil), forCellReuseIdentifier: "CircuitCell")
        let backgroundImage = UIImage(named: "bkhomelow.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        tableView.sectionHeaderHeight = 100
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
        return circuits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let circuitCell = tableView.dequeueReusableCell(withIdentifier: "CircuitCell", for: indexPath) as! CircuitCell
        let circuit = circuits[indexPath.row]
        circuitCell.nameCircuit.text = circuit.name
        circuitCell.kmsCircuit.text = NSString(format: "%.2f", circuit.distanceInKm) as String + " km"
        
        if device.isSimulator{
            if !device.isOneOf(groupDevicesSimulator){
                circuitCell.nameCircuit.font = circuitCell.nameCircuit.font.withSize(17.5)
                circuitCell.kmsCircuit.font = circuitCell.kmsCircuit.font.withSize(17.5)
            }
        }else{
            if !device.isOneOf(groupDevices){
                circuitCell.nameCircuit.font = circuitCell.nameCircuit.font.withSize(17.5)
                circuitCell.kmsCircuit.font = circuitCell.kmsCircuit.font.withSize(17.5)
            }
        }
        
        return circuitCell

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 55
        
        if device.isSimulator{
            if device.isOneOf(groupDevicesSimulator){
                height = 45
            }
        }else{
            if device.isOneOf(groupDevices){
                height = 45
            }
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProfileCircuitSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileCircuitSegue"{
            let profileCircuit = segue.destination as! ProfileCircuitTableViewController
            let row = tableView.indexPathForSelectedRow?.row
            let circuit = circuits[row!]
            profileCircuit.circuit = circuit
            
        }
    }
    

}


extension ListCircuitTableViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let userLocation = locations.first{
            getCircuitsHttp(userLocation)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
}

