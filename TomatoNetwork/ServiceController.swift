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
        if !(FileManager.default.fileExists(atPath: LAUNCH_AGENT_PLIST)){
            try? FileManager.default.createDirectory(atPath: LAUNCH_AGENT_PLIST, withIntermediateDirectories: true)
        }
        services.forEach({(key:String, value:Dictionary<String, Any>) -> Void in
            NSLog("initialize \(key)")
            let serviceType:ServiceProtocol.Type = (value["service"] as! ServiceProtocol.Type)
            let service:ServiceProtocol = serviceType.init()
            service.setupService()
            let plist:String = "\(LAUNCH_AGENT_PLIST)/\(value["plist"] as! String)"
            service.generateLaunchdPlist().write(toFile: plist, atomically: true)
            let task = Process.launchedProcess(launchPath: "/bin/launchctl", arguments: ["load", plist])
            task.waitUntilExit()
        })
    }
    
    public func uninstallService() {
        services.forEach({(key:String, value:Dictionary<String, Any>) -> Void in
            let plist:String = "\(LAUNCH_AGENT_PLIST)/\(value["plist"] as! String)"
            let task = Process.launchedProcess(launchPath: "/bin/launchctl", arguments: ["unload", plist])
            task.waitUntilExit()
        })
    }
}
