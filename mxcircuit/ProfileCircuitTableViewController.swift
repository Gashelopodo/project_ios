//
//  ProfileCircuitTableViewController.swift
//  mxcircuit
//
//  Created by Mario alcazar on 29/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MapKit

var notificationsGlobal : [NotificationM] = []
var profileTableView = UITableView()

class ProfileCircuitTableViewController: UITableViewController {
    
    // VARS
    var circuit : Circuit!
    var idCircuit : String?
    var indicator = UIActivityIndicatorView()
    var backgroundIndicator = UIView()
    var vote : Bool = false
    var votes = [Int]()
    var votesClick : [Bool] = [false, false, false, false, false]
    var control : Bool = false
    var newTableView = NewTableView()
    var locationManager = CLLocationManager()
    
    // OUTLET
    @IBOutlet weak var logoCircuit: UIImageView!
    @IBOutlet weak var nameCircuit: UILabel!
    @IBOutlet weak var kmCircuit: UILabel!
    @IBOutlet weak var imageCircuit: UIImageView!
    @IBOutlet weak var descripctionCircuit: UILabel!
    @IBOutlet weak var hourCircuit: UILabel!
    @IBOutlet weak var priceCircuit: UILabel!
    @IBOutlet weak var barCircuit: UIImageView!
    @IBOutlet weak var bathroomCircuit: UIImageView!
    @IBOutlet weak var photoCircuit: UIImageView!
    @IBOutlet weak var lavaderoCircuit: UIImageView!
    @IBOutlet weak var cronoCircuit: UIImageView!
    @IBOutlet weak var barText: UILabel!
    @IBOutlet weak var barthroomText: UILabel!
    @IBOutlet weak var photoText: UILabel!
    @IBOutlet weak var lavaderoText: UILabel!
    @IBOutlet weak var cronoText: UILabel!
    @IBOutlet weak var photoValue: UILabel!
    @IBOutlet weak var contactNameCircuit: UILabel!
    @IBOutlet weak var emailContactCircuit: UILabel!
    @IBOutlet weak var phoneContactCircuit: UILabel!
    @IBOutlet weak var addressContactCircuit: UILabel!
    @IBOutlet weak var youtube: UIWebView!
    @IBOutlet weak var titleWeather: UILabel!
    @IBOutlet weak var day_1: UILabel!
    @IBOutlet weak var icon_1: UIImageView!
    @IBOutlet weak var high_1: UILabel!
    @IBOutlet weak var low_1: UILabel!
    @IBOutlet weak var day_2: UILabel!
    @IBOutlet weak var icon_2: UIImageView!
    @IBOutlet weak var high_2: UILabel!
    @IBOutlet weak var low_2: UILabel!
    @IBOutlet weak var day_3: UILabel!
    @IBOutlet weak var icon_3: UIImageView!
    @IBOutlet weak var high_3: UILabel!
    @IBOutlet weak var low_3: UILabel!
    @IBOutlet weak var day_4: UILabel!
    @IBOutlet weak var icon_4: UIImageView!
    @IBOutlet weak var high_4: UILabel!
    @IBOutlet weak var low_4: UILabel!
    @IBOutlet weak var day_5: UILabel!
    @IBOutlet weak var icon_5: UIImageView!
    @IBOutlet weak var high_5: UILabel!
    @IBOutlet weak var low_5: UILabel!
    @IBOutlet weak var day_6: UILabel!
    @IBOutlet weak var icon_6: UIImageView!
    @IBOutlet weak var high_6: UILabel!
    @IBOutlet weak var low_6: UILabel!
    @IBOutlet var stars: [UIButton]!
    @IBOutlet weak var buttonVote: UIButton!
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var buttonMap: UIButton!
    

    // ACTION
    @IBAction func clickStar(_ sender: UIButton) {
        
        if vote {
            
            var tag : Int = 1
            var position : Int = 0
            
            switch sender.tag {
            case 1...5:
                tag = 1
                position = 0
            case 6...10:
                tag = 6
                position = 1
            case 11...15:
                tag = 11
                position = 2
            case 16...20:
                tag = 16
                position = 3
            case 21...25:
                tag = 21
                position = 4
            default: break
            }
            
            var i : Int = 0
            for star in stars {
                if star.tag >= tag && star.tag <= sender.tag{
                    star.setImage(UIImage(named: "staron"), for: .normal)
                    i += 1
                }else if star.tag >= tag && star.tag <= (tag+4){
                    star.setImage(UIImage(named: "staroff"), for: .normal)
                }
            }
            
            votes.insert(i, at: position)
            votesClick[position] = true
            
            checkVotes()
            
        }
        
    }
    
    @IBAction func voteAction(_ sender: UIButton) {
        
        if !vote {
            vote = true
            present(
                showAlert(
                    "Información",
                    messageData: "Valora cada categoría con las estrellas que consideres y una vez terminado pulsa de nuevo el botón VALORAR CIRCUITO. ¡Gracias por tu valoración!"
                ),
                animated: true,
                completion: {
                    self.resetStars()
                    self.buttonVote.alpha = CGFloat(0.1)
                }
            )
        }else{
            
            if(control){
                let review = Review(
                    pId: "",
                    pRegisterId: "",
                    pCircuitId: circuit.id!,
                    pInstallations: String(votes[0]),
                    pTerrain: String(votes[1]),
                    pIrrigation: String(votes[2]),
                    pJumps: String(votes[3]),
                    pSecurity: String(votes[4]),
                    pCreatedAt: ""
                )
                
                let setReview = SetReview(pReview: review)
                setReview.insert({ (response) in
                    if response?.code == Response_.OK{
                        self.present(showAlert("Información", messageData: (response?.message)!), animated: true, completion: nil)
                    }else{
                        self.present(showAlert("Hay un problema", messageData: (response?.message)!), animated: true, completion: nil)
                    }
                    self.resetData()
                })
                
            }
            
        }
        
    }
    
    @IBAction func goMap(_ sender: Any) {
        
        let latitude = CLLocationDegrees(circuit.lat!)!
        let longitude = CLLocationDegrees(circuit.lng!)!
    
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ] as [String : Any]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = circuit.name!
        mapItem.openInMaps(launchOptions: options)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check network
        guard let status = Network.reachability?.status else { return }
        if status == .unreachable{
            print("No hay internet")
            present(showAlert("Hay un problema", messageData: "No dispone de conexión a internet."), animated: true, completion: nil)
        }
        
        // load styles
        styles()
        
        // load data normal
        if self.circuit != nil{
            
            // load data
            loadData()
            
            // load youtube
            loadYoutube()
            
            // obtenemos el tiempo
            httpGetWeather()
            
            // load stars
            loadStars()
            
            getNotificationCircuit()
            
        }else{
            // load indicator
            loadIndicator()
        }
        
        profileTableView = self.tableView
        
        // Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func styles(){
        buttonMap.layer.cornerRadius = 15
        buttonMap.clipsToBounds = true
    }
    
    func getNotificationCircuit(){
        
        let getNotification = GetNotificationsUserToCircuit(token: getToken(), circuit_id: circuit.id!)
        getNotification.get { (notifications) in
            notificationsGlobal = notifications
            self.notificationTableView.delegate = self.newTableView
            self.notificationTableView.dataSource = self.newTableView
        }
    }
    
    func getCircuitsHttp(_ userLocation : CLLocation){
        // traemos listado de circuitos
        if self.idCircuit == nil{
            self.idCircuit = getIdCircuitNotification()
        }
        let getCircuits = GetCircuit(userLocation, self.idCircuit!)
        getCircuits.get { (circuit) in
            // ordenamos por distancia
            self.circuit = circuit
            
            // load data
            self.loadData()
            
            // load youtube
            self.loadYoutube()
            
            // obtenemos el tiempo
            self.httpGetWeather()
            
            // load stars
            self.loadStars()
            
            self.getNotificationCircuit()
            
            self.indicator.stopAnimating()
            self.backgroundIndicator.removeFromSuperview()
            
        }
    }
    
    func resetData(){
        votesClick = [false, false, false, false, false]
        votes = [Int]()
        control = false
        vote = false
    }
    
    func checkVotes(){
        var control : Bool = true
        for b in votesClick{
            if !b{
                control = b
            }
        }
        
        if control{
            buttonVote.alpha = CGFloat(1.0)
            self.control = true
        }
        
    }
    
    func loadStars(){
        
        var installation : Double = 0
        var terrain : Double = 0
        var irrigation : Double = 0
        var jumps : Double = 0
        var security : Double = 0
        let size : Double = Double(circuit.review.count)
        
        for review in circuit.review{
            installation += Double(review.installations!)!
            terrain += Double(review.terrain!)!
            irrigation += Double(review.irrigation!)!
            jumps += Double(review.jumps!)!
            security += Double(review.security!)!
        }
        
        print(installation, terrain, irrigation, jumps, security)
        
        installation = (installation/size).rounded()
        terrain = (terrain/size).rounded()
        irrigation = (irrigation/size).rounded()
        jumps = (jumps/size).rounded()
        security = (security/size).rounded()
        
        print(installation, terrain, irrigation, jumps, security)
        
        for star in stars {
            switch star.tag {
            case 1...5:
                if Double(star.tag) <= installation{
                    star.setImage(UIImage(named: "staron"), for: .normal)
                }
            case 6...10:
                if Double(star.tag)-5 <= terrain{
                    star.setImage(UIImage(named: "staron"), for: .normal)
                }
            case 11...15:
                if Double(star.tag)-10 <= irrigation{
                    star.setImage(UIImage(named: "staron"), for: .normal)
                }
            case 16...20:
                if Double(star.tag)-15 <= jumps{
                    star.setImage(UIImage(named: "staron"), for: .normal)
                }
            case 21...25:
                if Double(star.tag)-20 <= security{
                    star.setImage(UIImage(named: "staron"), for: .normal)
                }
            default: break
            }
        }
        
        
    }
    
    func resetStars(){
        
        for star in stars {
            star.setImage(UIImage(named: "staroff"), for: .normal)
        }
        
    }
    
    func httpGetWeather(){
        let getWeather = GetWeather(circuit: circuit)
        getWeather.get { (weathers) in
            if let dataFromString = (weathers[0].weather!).data(using: .utf8, allowLossyConversion: false){
                let weather = JSON(dataFromString)
                print(weather)
                self.loadWeather(weather)
            }
        }
    }
    
    func loadData(){
        
        logoCircuit.image = UIImage(data: getImageUrl(CONSTANTS.URLS.BASE + circuit.logo!) as Data)
        nameCircuit.text = circuit.name!
        kmCircuit.text = NSString(format: "%.2f", circuit.distanceInKm) as String + " km"
        imageCircuit.image = UIImage(data: getImageUrl(CONSTANTS.URLS.BASE + circuit.picture!) as Data)
        descripctionCircuit.text = circuit.desc!
        descripctionCircuit.sizeToFit()
        hourCircuit.text = "Horarios: " + circuit.hours!
        priceCircuit.text = "Precio: " + circuit.price!
        
        if circuit.bar! != "No" {
            barCircuit.image = UIImage(named: "bar_on.png")
            barText.textColor = UIColor.black
        }
        
        if circuit.bathroom! != "No" {
            bathroomCircuit.image = UIImage(named: "bano_on.png")
            barthroomText.textColor = UIColor.black
        }
        
        if circuit.photo! != "No" {
            photoCircuit.image = UIImage(named: "fotografo_on.png")
            photoText.textColor = UIColor.black
            photoValue.text = circuit.photo!
        }
        
        if circuit.lavado! != "No" {
            lavaderoCircuit.image = UIImage(named: "lavadero_on.png")
            lavaderoText.textColor = UIColor.black
        }
       
        if circuit.cronos! != "No" {
            cronoCircuit.image = UIImage(named: "chrono_on.png")
            cronoText.textColor = UIColor.black
        }
        
        contactNameCircuit.text = "Nombre: " + circuit.contact_name!
        emailContactCircuit.text = "Email: " + circuit.contact_email!
        phoneContactCircuit.text = "Teléfono: " + circuit.contact_phone!
        addressContactCircuit.text = "Dirección: " + circuit.address!
    
        
    }
    
    func loadYoutube(){
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/"+circuit.video!+"?rel=0&amp;showinfo=0")
        else {
            return
        }
        youtube.loadRequest(URLRequest(url: youtubeURL))
    }
    
    func loadWeather(_ weather : JSON){
        titleWeather.text = circuit.address!
        day_1.text = translateDay( weather[0]["day"].string!, CONSTANTS.UTILS.LONG)
        day_2.text = translateDay( weather[1]["day"].string!, CONSTANTS.UTILS.SHORT)
        day_3.text = translateDay( weather[2]["day"].string!, CONSTANTS.UTILS.SHORT)
        day_4.text = translateDay( weather[3]["day"].string!, CONSTANTS.UTILS.SHORT)
        day_5.text = translateDay( weather[4]["day"].string!, CONSTANTS.UTILS.SHORT)
        day_6.text = translateDay( weather[5]["day"].string!, CONSTANTS.UTILS.SHORT)
        icon_1.image = UIImage(named: "icon_"+weather[0]["code"].string!)
        icon_2.image = UIImage(named: "icon_"+weather[1]["code"].string!)
        icon_3.image = UIImage(named: "icon_"+weather[2]["code"].string!)
        icon_4.image = UIImage(named: "icon_"+weather[3]["code"].string!)
        icon_5.image = UIImage(named: "icon_"+weather[4]["code"].string!)
        icon_6.image = UIImage(named: "icon_"+weather[5]["code"].string!)
        high_1.text = " \(toCentigrados(Double(weather[0]["high"].string!)!))º"
        high_2.text = " \(toCentigrados(Double(weather[1]["high"].string!)!))º"
        high_3.text = " \(toCentigrados(Double(weather[2]["high"].string!)!))º"
        high_4.text = " \(toCentigrados(Double(weather[3]["high"].string!)!))º"
        high_5.text = " \(toCentigrados(Double(weather[4]["high"].string!)!))º"
        high_6.text = " \(toCentigrados(Double(weather[5]["high"].string!)!))º"
        low_1.text = " \(toCentigrados(Double(weather[0]["low"].string!)!))º"
        low_2.text = " \(toCentigrados(Double(weather[1]["low"].string!)!))º"
        low_3.text = " \(toCentigrados(Double(weather[2]["low"].string!)!))º"
        low_4.text = " \(toCentigrados(Double(weather[3]["low"].string!)!))º"
        low_5.text = " \(toCentigrados(Double(weather[4]["low"].string!)!))º"
        low_6.text = " \(toCentigrados(Double(weather[5]["low"].string!)!))º"
    }
    
    func loadIndicator(){
        
        let size = 50
        let screen = UIScreen.main.bounds
        backgroundIndicator = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
        backgroundIndicator.backgroundColor = UIColor.white
        backgroundIndicator.layer.zPosition = 1000
        self.view.addSubview(backgroundIndicator)
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = CGPoint(x: Int((Float(UIScreen.main.bounds.width)/2)), y: 120)
        indicator.layer.zPosition = 1001
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        
        
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
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if indexPath.row == 4 && indexPath.section == 0{
            return descripctionCircuit.frame.height + 50
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
    }
 
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
    }
    

}



class NewTableView: UITableViewController{
    
    var notifications = [NotificationM]()
    var size = CGFloat(0)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let notifications = ProfileCircuitTableViewController().getNotifications()
        
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row]
        
        notificationCell.titleCircuit.text = notification.name_circuit
        notificationCell.descriptionNotification.text = notification.desc
        notificationCell.dateNotification.text = convertDate(notification.created_at!)
        
        notificationCell.titleCircuit.sizeToFit()
        notificationCell.descriptionNotification.sizeToFit()
        notificationCell.dateNotification.sizeToFit()
        
        size += notificationCell.descriptionNotification.frame.height + notificationCell.titleCircuit.frame.height + notificationCell.dateNotification.frame.height
        
        print(notifications.count, indexPath.row)
        
    
        return notificationCell
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(notifications.count == 0){
            setAtributtesTable(tableView)
        }
        return notifications.count
    }
    
    func setAtributtesTable(_ tableView : UITableView){
        
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.backgroundColor = UIColor.white
        tableView.sectionHeaderHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        //tableView.isScrollEnabled = false
        
        notifications = notificationsGlobal
        
        if(notifications.count > 0){
            tableView.reloadData()
        }else{
            notifications.append(
                NotificationM(
                    pId: "",
                    pNameCircuit: "",
                    pNotificationId: "",
                    pRegisterId: "",
                    pCircuitId: "",
                    pTitle: "",
                    pDesc: "Este circuito aún no ha mandado ninguna notificación",
                    pSend: "",
                    pStatus: "",
                    pMessageStatus: "",
                    pCreatedAt: ""
                )
            )
            tableView.reloadData()
        }
        
        
        
    }
    
    
}


extension ProfileCircuitTableViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let userLocation = locations.first{
            if self.circuit == nil{
                getCircuitsHttp(userLocation)
            }
        }
        
    }
    
}






