//
//  MetricsService.swift
//  Speed Test
//
//  Created by Paul Shelton on 5/29/19.
//  Copyright © 2019 Paul Shelton. All rights reserved.
//

import Foundation

protocol MetricServiceDelegate{
    //these should really send back the errors
    func LogMetricsComplete(result: Bool)
    func CreateSessionComplete(result: Bool)
}

public class MetricsService
{
    var baseUrl: String
    var delegate: MetricServiceDelegate?
    
    public init(baseUrl: String){
    
        self.baseUrl = baseUrl;
    }
    
    public func LogMetrics(speed: Float64,
                           longitude: Float64,
                           latitude: Float64,
                           sessionID: UInt64) {
        
        let url = String( format:"%@/ipmetrics?Speed=%f&Latitude=%f&Longitude=%f&SessionID=%d",
                          self.baseUrl,
                          speed,
                          latitude,
                          longitude,
                          sessionID);
        
        let urlString = URL(string: url)  // Making the URL
        
        if let urla = urlString {
            let task = URLSession.shared.dataTask(with: urla) {
                (data, response, error) in // Creating the URL Session.
                if(self.delegate != nil) {
                    self.delegate?.LogMetricsComplete(result: error != nil )
                }
            }
            task.resume()
        }
    }
    
    public func CreateSession(sessionID: UInt64, sessionTitle: String, comments: String, addedBy:String){
        let url = String( format:"%@/addsession?SessionID=%d&Title=%@&Comments=%@&AddedBy=%@&Distance=0",
                          self.baseUrl,
                          sessionID,
                          sessionTitle,
                          comments,
                          addedBy);
        
        let urlString = URL(string: url)  // Making the URL
        if let urla = urlString {
            let task = URLSession.shared.dataTask(with: urla) {
                (data, response, error) in // Creating the URL Session.
                if(self.delegate != nil) {
                    self.delegate?.CreateSessionComplete(result: error != nil )
                }
            }
            task.resume()
        }
    }
}
