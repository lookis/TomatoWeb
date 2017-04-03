//
//  AppDelegate.swift
//  Launcher
//
//  Created by Lookis on 02/04/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainApplicationIdentifier = "me.lookis.tomato.web"
        let running = NSWorkspace.shared().runningApplications
        var alreadyRunning = false
        
        for app in running {
            if app.bundleIdentifier == mainApplicationIdentifier {
                alreadyRunning = true
                break
            }
        }
        
        if !alreadyRunning{
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("TomatoWeb")
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared().launchApplication(newPath)
        }
        NSApp.terminate(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSApp.terminate(nil)
    }


}

