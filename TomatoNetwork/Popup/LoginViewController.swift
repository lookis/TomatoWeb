//
//  LoginViewController.swift
//  TomatoNetwork
//
//  Created by Lookis on 10/05/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    
    let USERNAME = "username"
    let PASSWORD = "password"
    
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSTextField!
    @IBOutlet weak var btnLogin: NSButton!
    @IBOutlet weak var btnRegister: NSButton!
    @IBOutlet weak var btnForgot: NSButton!
    @IBOutlet weak var textTitle: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true;
        self.view.layer?.contents = NSColor.init(red: 246, green: 246, blue: 246, alpha: 0)
        renderBlueButton(btn: btnRegister);
        renderBlueButton(btn: btnForgot);
        textTitle.stringValue = "\("Hi there! Welcome to Tomato Network".localized) \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
        
        if let savedUsername = UserDefaults.standard.string(forKey: USERNAME) {
            username.stringValue = savedUsername
            if let savedPassword = UserDefaults.standard.string(forKey: PASSWORD) {
                password.stringValue = savedPassword
            }
        }
    }
    
    func renderBlueButton(btn: NSButton) {
        let colorTitle = NSMutableAttributedString.init(string: btn.title)
        let titleRange = NSMakeRange(0, colorTitle.length);
        colorTitle.addAttribute(NSForegroundColorAttributeName, value: NSColor.blue, range: titleRange)
        btn.attributedTitle = colorTitle;
    }
    
    @IBAction func handleForgot(sender: NSButton) {
        NSWorkspace.shared().open(URL.init(string: "http://tomato.network/forgot")!);
    }
    
    @IBAction func handleRegister(sender: NSButton) {
        NSWorkspace.shared().open(URL.init(string: "http://tomato.network/register")!);
    }
    
    @IBAction func handleLogin(sender: NSButton) {
        self.view.window?.makeFirstResponder(nil);
        MBProgressHUD.showAdded(to: self.view, animated: true);
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(logined), userInfo: sender, repeats: false)
    }
    
    func logined(sender: NSButton){
        NSAnimationContext.beginGrouping();
        NSAnimationContext.current().completionHandler = {() in
            let parentController = self.parent as! PopupTabViewController
            parentController.tabView.selectNextTabViewItem(sender)
        }
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
        NSAnimationContext.endGrouping();
        
    }
}
