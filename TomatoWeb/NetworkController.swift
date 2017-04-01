//
//  NetworkController.swift
//  TomatoWeb
//
//  Created by Lookis on 01/04/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation
import ServiceManagement

let kHelperToolMachServiceName = "me.lookis.tomato.NetworkHelper"

public class NetworkController {
    
    var helperToolConnection:NSXPCConnection? = nil
    
    public func installHelper() -> Bool{
        var success:Bool = false
        var error:Unmanaged<CFError>? = nil
        var authRef:AuthorizationRef? = nil;
        
        AuthorizationCreate(nil, nil, AuthorizationFlags(rawValue: 0), &authRef);
        success = SMJobBless(
            kSMDomainSystemLaunchd,
            "me.lookis.tomato.NetworkHelper" as CFString,
            authRef,
            &error
        );
        
        if (success) {
            NSLog("success")
        } else {
            print(error ?? "");
            error!.release()
        }
        return success
    }
    
    public func clearNetworkSetting(){
        connectAndExecute {
            let networkHelper = helperToolConnection?.remoteObjectProxyWithErrorHandler({(error:Error) -> Void in
                print(error);
            }) as! NetworkHelperProtocol
            networkHelper.clearNetworkSetting(callback: {(any:Any?) -> Void in
                print(any)
            })
        }
    }
    
    func connectAndExecute(block:()->Void){
        connectToHelperTool()
        block()
    }
    
    func connectToHelperTool(){
        if (helperToolConnection == nil){
            helperToolConnection = NSXPCConnection.init(machServiceName: kHelperToolMachServiceName, options: NSXPCConnection.Options.privileged)
            helperToolConnection?.remoteObjectInterface = NSXPCInterface.init(with: NetworkHelperProtocol.self)
            helperToolConnection?.invalidationHandler = {() -> Void in
                self.helperToolConnection?.invalidationHandler = nil
                OperationQueue.main.addOperation {
                    self.helperToolConnection = nil
                    NSLog("connection invalid")
                }
            }
            helperToolConnection?.resume()
        }
    }
    
}
