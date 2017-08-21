//
//  MainViewController.swift
//  TomatoNetwork
//
//  Created by Lookis on 22/05/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBAction func handleBack(_ sender: Any) {
        let parentController = self.parent as! PopupTabViewController
        parentController.tabView.selectPreviousTabViewItem(sender);
    }

    @IBAction func handleSendMail(_ sender: NSButton) {
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)!
        service.recipients = ["features@tomato.network"]
        service.subject = "Good ideas".localized
        service.perform(withItems: [" ", " ", " ", " ", "> \("Tomato Network".localized) (\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String))", "> \("From".localized): test@tomato.network"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    
}
