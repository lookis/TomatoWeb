//
//  AppDelegate.swift
//  Launcher
//
//  Created by Lookis on 02/04/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa
import Foundation

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
            
            var path = Bundle.main.bundlePath as NSString
            if (!path.hasPrefix("/Application")){
                let tryPath = String.init(format: "/Application/%@", path.substring(from: path.range(of: String.init(format: "%@.app", Bundle.main.infoDictionary?["CFBundleExecutable"] as! String)).location));
                if (FileManager.default.fileExists(atPath: tryPath)) {
                    path = tryPath as NSString
                }
            }
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("TomatoNetwork")
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared().launchApplication(newPath)
        }
        NSApp.terminate(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSApp.terminate(nil)
    }


}

