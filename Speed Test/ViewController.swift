//
//  ViewController.swift
//  Speed Test
//
//  Created by Paul Shelton on 3/6/19.
//  Copyright © 2019 Paul Shelton. All rights reserved.
//
//TODO:
//Add target pace feature with vibration feedback
//Add "end session" feature to prevent them from having to reopen the app

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MetricServiceDelegate {
    
    var metricsService: MetricsService?;
    var locationManager = CLLocationManager();
    var timer:Timer!;
    var ipMetricsRootURL:String = "";
    
    override func viewDidLoad( ) {
        super.viewDidLoad();
        //self.session = UInt64( Date().timeIntervalSince1970);
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                self.ipMetricsRootURL = dict["IPMetricsServiceURL"] as! String
            }
        }
        
        self.metricsService = MetricsService(baseUrl: self.ipMetricsRootURL);
        
        // Do any additional setup after loading the view, typically from a nib.
        self.statusLabel.text = "0";
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(ViewController.update),
                                     userInfo: nil, repeats: true)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation();
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation])
    {
        if (didUpdateLocations.count == 0) { return }
        
        if let locationData = locationManager.location {
            self.metricsService?.LogMetrics(speed: locationData.speed,
                                           longitude: locationData.coordinate.longitude,
                                           latitude: locationData.coordinate.latitude,
                                           sessionID: session)
        }
    }
    
    func LogMetricsComplete(result: Bool) {
        
    }
    
    func CreateSessionComplete(result: Bool) {
        
    }
    
    @IBAction func onButtonPush(_ sender: Any) {
        self.getMotion();
        
    }
    @IBOutlet weak var btnSpeed: UIButton!
    
    @IBAction func doIt(_ sender: Any) {
        self.getMotion();
    }
    
    private func getMotion(){
        
        var speed: CLLocationSpeed = CLLocationSpeed()
        speed = Double((locationManager.location?.speed)!)
        
        //self.statusLabel.text = String(format: "%.02f", speed * 2.23694); //MPH
        self.statusLabel.text = String(format: "%.02f", speed * 26.8224); //PACE
        
    }
    
    @objc func update() {
      
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    
}

