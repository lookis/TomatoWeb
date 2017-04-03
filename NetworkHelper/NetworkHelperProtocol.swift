//
//  NetworkHelperProtocol.swift
//  TomatoWeb
//
//  Created by Lookis on 01/04/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation

@objc protocol NetworkHelperProtocol {
    
    func ping(callback: (_ pong:String) -> Void)
    
    func clearNetworkSetting()
    
    func setAutomaticProxyConfig(address:String!)
    
    func setSocksProxy(host:String!, port:NSNumber!)
    
}
