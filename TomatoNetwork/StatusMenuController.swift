//
//  StatusMenuController.swift
//  TomatoWeb
//
//  Created by Lookis on 27/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa
import Sparkle

class StatusMenuController: NSObject {
    
    var proxyOn = true
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var connectionSwitch: NSMenuItem!
    @IBOutlet weak var connectionStatus: NSMenuItem!
    @IBOutlet weak var version: NSMenuItem!
    @IBOutlet weak var launchAtLogin: NSMenuItem!
    @IBOutlet weak var popover: NSPopover!
    
    let NOT_LAUNCH_AT_STARTUP = "NOT_LAUNCH_AT_STARTUP"
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let networkController = NetworkController.sharedInstance
    
    override func awakeFromNib() {
        let icon = NSImage(named: "SystemTray")
        icon?.isTemplate = true
        if let button = statusItem.button {
            button.image = icon
            button.target = self
            button.action = #selector(self.handleClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        //start service
        connectionStatus.title = "Tomato Web: On".localized
        connectionSwitch.title = "Turn Off".localized
        //version
        version.title = "\("Version".localized): \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
        //launch on startup
        launchAtLogin.state = UserDefaults.standard.bool(forKey: NOT_LAUNCH_AT_STARTUP) ? NSOffState : NSOnState
        
        //Popover
        let storyboard = NSStoryboard.init(name: "TomatoNetwork", bundle: Bundle.main)
        popover.contentViewController = (storyboard.instantiateInitialController() as! NSViewController);
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
            connectionSwitch.title = "Turn On".localized
            connectionStatus.title = "Tomato Web: Off".localized
            networkController.clearNetworkSetting()
        }else{
            connectionSwitch.title = "Turn Off".localized
            connectionStatus.title = "Tomato Web: On".localized
            networkController.setAutomaticProxyConfig()
        }
        proxyOn = !proxyOn
    }
    
    func handleClicked(sender: NSStatusBarButton){
        if (self.popover.isShown){
            self.popover.performClose(sender)
        }else{
            self.popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.minY)
            NSApplication.shared().activate(ignoringOtherApps: true)
        }
        
    }
}
