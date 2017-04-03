//
//  AppDelegate.swift
//  TomatoWeb
//
//  Created by Lookis on 27/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa
import SystemConfiguration
import ServiceManagement
import Swifter
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let NOT_FIRST_LAUNCH = "NOT_FIRST_LAUNCH"
    let CURRENT_VERSION = "CURRENT_VERSION"
    
    let server = HttpServer();
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        #if DEBUG
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        NSLog("DEBUG MODE")
        #endif
        if UserDefaults.standard.string(forKey: CURRENT_VERSION) != (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String){
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.set((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String), forKey: CURRENT_VERSION)
            NSLog("clean UserDefaults on update or new install")
        }
        
        SMLoginItemSetEnabled("me.lookis.tomato.Launcher" as CFString, true);
        let serviceController = ServiceController()
        let networkController = NetworkController.sharedInstance
        //first launch
        if(!UserDefaults.standard.bool(forKey: NOT_FIRST_LAUNCH)){
            UserDefaults.standard.set(true, forKey: NOT_FIRST_LAUNCH)
            serviceController.uninstallService()
        }
        serviceController.installService()
        networkController.ping()
        server["/proxy.pac"] = shareFile(Bundle.main.resourcePath! + "/proxy.pac")
        try? server.start(in_port_t(PACPort), forceIPv4: true)
        networkController.setAutomaticProxyConfig()
        SUUpdater.shared().automaticallyDownloadsUpdates = true
        SUUpdater.shared().automaticallyChecksForUpdates = true
        SUUpdater.shared().resetUpdateCycle();
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NetworkController.sharedInstance.clearNetworkSetting()
        server.stop()
    }

}

