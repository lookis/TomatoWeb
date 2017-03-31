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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ServiceController().installService()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

