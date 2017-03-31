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
    
    let LAUNCH_AGENT_PLIST = "\(NSHomeDirectory())/Library/LaunchAgents"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog(Bundle.main.bundlePath)
        //        let bundle = Bundle.main
        //        let installerPath = bundle.path(forResource: "start_ss_local.sh", ofType: nil)
        //        let task = Process.launchedProcess(launchPath: installerPath!, arguments: [""])
        //        task.waitUntilExit()
        //        if task.terminationStatus == 0 {
        //            NSLog("Start ss-local succeeded.")
        //        } else {
        //            NSLog("Start ss-local failed.")
        //        }
        ServiceController().installService()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

