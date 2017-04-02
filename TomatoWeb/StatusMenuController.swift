//
//  StatusMenuController.swift
//  TomatoWeb
//
//  Created by Lookis on 27/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    
    var proxyOn = true
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var connectionSwitch: NSMenuItem!
    @IBOutlet weak var connectionStatus: NSMenuItem!
    @IBOutlet weak var launchAtLogin: NSMenuItem!
    
    let NOT_LAUNCH_AT_STARTUP = "NOT_LAUNCH_AT_STARTUP"
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let networkController = NetworkController.sharedInstance
    override func awakeFromNib() {
        let icon = NSImage(named: "SystemTray")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        //start service
        connectionStatus.title = "Tomato Web: On"
        connectionSwitch.title = "Turn Off"
        //launch on startup
        launchAtLogin.state = UserDefaults.standard.bool(forKey: NOT_LAUNCH_AT_STARTUP) ? NSOffState : NSOnState
    }
    
    @IBAction func handleLaunchAtLogin(_ sender: Any) {
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: NOT_LAUNCH_AT_STARTUP), forKey: NOT_LAUNCH_AT_STARTUP)
        launchAtLogin.state = UserDefaults.standard.bool(forKey: NOT_LAUNCH_AT_STARTUP) ? NSOffState : NSOnState
        if(UserDefaults.standard.bool(forKey: NOT_LAUNCH_AT_STARTUP)){
            
        }else{
            
        }
    }
    
    @IBAction func handleQuit(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    @IBAction func handleTurnOnOff(_ sender: NSMenuItem) {
        if (proxyOn){
            connectionSwitch.title = "Turn On"
            connectionStatus.title = "Tomato Web: Off"
            networkController.clearNetworkSetting()
        }else{
            connectionSwitch.title = "Turn Off"
            connectionStatus.title = "Tomato Web: On"
            networkController.setAutomaticProxyConfig()
        }
        proxyOn = !proxyOn
    }
}
