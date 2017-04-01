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
    let HELPER_INSTALLED = "HELPER_INSTALLED"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        #if DEBUG
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        NSLog("DEBUG MODE")
        #endif
        let serviceController = ServiceController()
        let networkController = NetworkController()
        //first launch
        if(!UserDefaults.standard.bool(forKey: NOT_FIRST_LAUNCH)){
            UserDefaults.standard.set(true, forKey: NOT_FIRST_LAUNCH)
            serviceController.uninstallService();
        }
        if(!UserDefaults.standard.bool(forKey: HELPER_INSTALLED)){
            let result = networkController.installHelper()
            UserDefaults.standard.set(result, forKey: HELPER_INSTALLED)
        }
        
        serviceController.installService()
        networkController.clearNetworkSetting()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

