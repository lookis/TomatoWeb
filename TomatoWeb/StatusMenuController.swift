//
//  StatusMenuController.swift
//  TomatoWeb
//
//  Created by Lookis on 27/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var connectionSwitch: NSMenuItem!
    @IBOutlet weak var connectionStatus: NSMenuItem!
    @IBOutlet weak var launchAtLogin: NSMenuItem!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "SystemTray")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func handleLaunchAtLogin(_ sender: Any) {
    }
    @IBAction func handleQuit(_ sender: NSMenuItem) {
    }
    @IBAction func handleTurnOnOff(_ sender: NSMenuItem) {
    }
}
