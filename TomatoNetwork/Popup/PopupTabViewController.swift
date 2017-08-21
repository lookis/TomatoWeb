//
//  PopupTabViewController.swift
//  TomatoNetwork
//
//  Created by Lookis on 12/05/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa

class PopupTabViewController: NSTabViewController {
    
    lazy var originalSizes = [String : NSSize]()
    
    enum OnlineState: StateType {
        case Start, Disconnected, Connected, Offline
    }
    
    enum OnlineEvent: EventType {
        case HasTicket, NoTicket, Logout, Login, DisableProxy, EnableProxy
    }
    
    let machine = StateMachine<OnlineState, OnlineEvent>(state: .Start){ machine in
        machine.addRoute(event: HasTicket, transitions: [
            .Start => .Disconnected
        ])
        machine.addRoute(event: NoTicket, tranbsitions: [
            .Start => .Offline
        ])
        machine.addRoute(event: Logout, transitions: [
            .Disconnected => .Offline,
            .Connected => .Offline,
        ])
        machine.addRoute(event: Login, transitions: [
            .Offline => .Connected
        ])
        machine.addRoute(event: DisableProxy, transitions: [2
            .Connected => .Disconnected
        ])
        machine.addRoute(event: EnableProxy, transitions: [
            .Disconnected => .Connected
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabView.delegate = self;
        self.tabViewItems.forEach({(tabViewItem: NSTabViewItem) in
            originalSizes[tabViewItem.label] = tabViewItem.view?.bounds.size;
        })
        tabView.selectLastTabViewItem(self);
    }
    
    override func viewWillAppear() {
        let tabViewItem = tabViewItems[self.selectedTabViewItemIndex]
        resizeWindowToFit(tabViewItem: tabViewItem)
    }
    
    override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, willSelect: tabViewItem);
        if let tabViewItem = tabViewItem {
            resizeWindowToFit(tabViewItem: tabViewItem)
        }
    }
    
    private func resizeWindowToFit(tabViewItem: NSTabViewItem) {
        guard let size = originalSizes[tabViewItem.label], let window = view.window else {
            return
        }
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let contentFrame = window.frameRect(forContentRect: contentRect)
        let toolbarHeight = window.frame.size.height - contentFrame.size.height
        let newOrigin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y + toolbarHeight)
        let newFrame = NSRect(origin: newOrigin, size: contentFrame.size)
        window.setFrame(newFrame, display: false, animate: false)
    }
    

}
