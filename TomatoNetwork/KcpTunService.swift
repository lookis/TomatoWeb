//
//  KcpTunService.swift
//  TomatoWeb
//
//  Created by Lookis on 30/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation

public class KcpTunService: ServiceProtocol{
    
    let APP_SUPPORT_DIR = "\(NSHomeDirectory())/Library/Application Support/me.lookis.kcptun"
    
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
            try fm.createSymbolicLink(atPath: APP_SUPPORT_DIR, withDestinationPath: "\(Bundle.main.resourcePath!)/Services/KcpTun/20170322")
        }catch{
            print(error)
        }
    }
    
    public func generateLaunchdPlist() -> NSMutableDictionary! {
        let arguments = ["\(APP_SUPPORT_DIR)/kcptun_client", "-c", "kcptun-config.json"]
        let dict: NSMutableDictionary = [
            "Label": "me.lookis.kcptun",
            "WorkingDirectory": APP_SUPPORT_DIR,
            "KeepAlive": true,
            "Program": "\(APP_SUPPORT_DIR)/kcptun_client",
            "ProgramArguments": arguments,
            "EnvironmentVariables": ["DYLD_LIBRARY_PATH": APP_SUPPORT_DIR]
        ]
        return dict
    }
}
