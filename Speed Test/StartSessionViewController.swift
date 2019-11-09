//
//  StartSessionViewController.swift
//  Speed Test
//
//  Created by Paul Shelton on 5/24/19.
//  Copyright © 2019 Paul Shelton. All rights reserved.
//

import Foundation
import UIKit

var session:UInt64 = 0;

public class StartSessionViewController: UIViewController, MetricServiceDelegate{
    var ipMetricsRootURL:String?;
    var metricsService: MetricsService?;
    
    func LogMetricsComplete(result: Bool) {
        
    }
    
    func CreateSessionComplete(result: Bool) {
        DispatchQueue.main.async {
            self.self.navigateToSessionController();
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                self.ipMetricsRootURL = (dict["IPMetricsServiceURL"] as! String)
            }
        }
        self.metricsService = MetricsService(baseUrl: self.ipMetricsRootURL!);
        self.metricsService?.delegate = self;
        session = UInt64( Date().timeIntervalSince1970);
    }
   
    @IBAction func onPush(_ sender: Any) {
        
        self.metricsService?.CreateSession(sessionID: session,
                                           sessionTitle: self.txtSessionName.text!,
                                           comments: self.txtComments.text!, addedBy: "pds");
    }
    
    @IBOutlet weak var txtComments: UITextField!;
    @IBOutlet weak var txtSessionName: UITextField!;
    
    private func navigateToSessionController(){
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainNavController =
            main.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
            return
        }
        
        present(mainNavController, animated: true,completion: nil)
    }
}
