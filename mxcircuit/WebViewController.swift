//
//  WebViewController.swift
//  mxcircuit
//
//  Created by Mario alcazar on 17/9/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    // VARS
    var urlweb : String?
    
    // OUTLET
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var titleurl: UILabel!
    
    // ACTION
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check network
        guard let status = Network.reachability?.status else { return }
        if status == .unreachable{
            print("No hay internet")
            present(showAlert("Hay un problema", messageData: "No dispone de conexión a internet."), animated: true, completion: nil)
        }
        
        webView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUrl(){
    
        titleurl.text = urlweb
        let url = URL(string: urlweb!)!
        let urlRequest = URLRequest(url: url)
        webView.loadRequest(urlRequest)
        
        
    }
    

}


extension WebViewController : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    
}
