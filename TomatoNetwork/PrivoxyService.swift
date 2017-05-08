//
//  PrivoxyService.swift
//  TomatoWeb
//
//  Created by Lookis on 30/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation

public class PrivoxyService : ServiceProtocol {
    
    let APP_SUPPORT_DIR = "\(NSHomeDirectory())/Library/Application Support/me.lookis.privoxy"
    
    public required init() {
    }
    
    public func setupService() {
        NSLog(APP_SUPPORT_DIR)
        let fm = FileManager.default
        do {
            if (fm.fileExists(atPath: APP_SUPPORT_DIR)){
                let attributes = try fm.attributesOfItem(atPath: APP_SUPPORT_DIR)
                if(attributes[FileAttributeKey.type] as? FileAttributeType == FileAttributeType.typeSymbolicLink){
                    return
                }
            }
            try? fm.removeItem(atPath: APP_SUPPORT_DIR)
            try fm.createSymbolicLink(atPath: APP_SUPPORT_DIR, withDestinationPath: "\(Bundle.main.resourcePath!)/Services/Privoxy")
        }catch{
            print(error)
        }
    }
    
    public func generateLaunchdPlist() -> NSMutableDictionary! {
        let arguments = ["\(APP_SUPPORT_DIR)/privoxy", "--no-daemon", "privoxy.conf"]
        let dict: NSMutableDictionary = [
            "Label": "me.lookis.privoxy",
            "WorkingDirectory": APP_SUPPORT_DIR,
            "Program": "\(APP_SUPPORT_DIR)/privoxy",
            "KeepAlive": true,
            "ProgramArguments": arguments
        ]
        return dict
    }
}
