//
//  AppDelegate.swift
//  TomatoWeb
//
//  Created by Lookis on 27/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa
import SystemConfiguration

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let NOT_FIRST_LAUNCH = "NOT_FIRST_LAUNCH"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let serviceController = ServiceController()
        //first launch
        if(!UserDefaults.standard.bool(forKey: NOT_FIRST_LAUNCH)){
            UserDefaults.standard.set(true, forKey: NOT_FIRST_LAUNCH)
            serviceController.uninstallService();
        }
        serviceController.installService()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

