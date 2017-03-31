//
//  ServiceController.swift
//  TomatoWeb
//
//  Created by Lookis on 31/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation

class ServiceController {
    var services = [
        "sslocal": [
            "service": SSLocalService.self,
            "plist": "me.lookis.ss-local.plist"
        ],
        "privoxy": [
            "service": PrivoxyService.self,
            "plist": "me.lookis.privoxy.plist"
        ],
        "kcptun": [
            "service": KcpTunService.self,
            "plist": "me.lookis.kcptun.plist"
        ]
    ]
    let LAUNCH_AGENT_PLIST = "\(NSHomeDirectory())/Library/LaunchAgents"
    
    public func installService() {
        
        services.forEach({(key:String, value:Dictionary<String, Any>) -> Void in
            NSLog("initialize \(key)")
            let serviceType:ServiceProtocol.Type = (value["service"] as! ServiceProtocol.Type)
            let service:ServiceProtocol = serviceType.init()
            service.setupService()
            service.generateLaunchdPlist().write(toFile: "\(LAUNCH_AGENT_PLIST)/\(value["plist"] as! String)", atomically: true)
            
        })
        let ss:ServiceProtocol! = SSLocalService()
        ss.setupService()
        ss.generateLaunchdPlist().write(toFile: "\(LAUNCH_AGENT_PLIST)/me.lookis.ss-local.plist", atomically: true)
        let privoxy:ServiceProtocol! = PrivoxyService()
        privoxy.setupService()
        privoxy.generateLaunchdPlist().write(toFile: "\(LAUNCH_AGENT_PLIST)/me.lookis.privoxy.plist", atomically: true)
        let kcptun:ServiceProtocol! = KcpTunService()
        kcptun.setupService()
        kcptun.generateLaunchdPlist().write(toFile: "\(LAUNCH_AGENT_PLIST)/me.lookis.kcptun.plist", atomically: true)
    }
}
