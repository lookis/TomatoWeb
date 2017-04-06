//
//  NetworkController.swift
//  TomatoWeb
//
//  Created by Lookis on 01/04/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation
import ServiceManagement

let PACPort = 8085
let kHelperToolMachServiceName = "me.lookis.tomato.NetworkHelper"

public class NetworkController {
    static let sharedInstance: NetworkController = NetworkController()
    let lock:NSLock = NSLock.init()
    var helperToolConnection:NSXPCConnection? = nil
    
    private init() { }
    
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
            let networkHelper = helperToolConnection?.remoteObjectProxy as! NetworkHelperProtocol
            networkHelper.clearNetworkSetting()
        }
    }
    
    public func setAutomaticProxyConfig(){
        connectAndExecute {
            let networkHelper = helperToolConnection?.remoteObjectProxy as! NetworkHelperProtocol
            NSLog("setAutomaticProxyConfig")
            networkHelper.setAutomaticProxyConfig(address: "http://127.0.0.1:\(PACPort)/proxy.pac")
        }
    }
    
    public func ping(){
        connectAndExecute {
            let networkHelper = helperToolConnection?.remoteObjectProxy as! NetworkHelperProtocol
            networkHelper.ping(callback: {(pong:String) -> Void in
                NSLog("ping");
            })
        }
    }
    
    func connectAndExecute(block:()->Void){
        connectToHelperTool()
        block()
    }
    
    func connectToHelperTool(){
        if (helperToolConnection == nil){
            lock.lock()
            defer{
                lock.unlock()
            }
            if (helperToolConnection == nil){
                helperToolConnection = NSXPCConnection.init(machServiceName: kHelperToolMachServiceName, options: NSXPCConnection.Options.privileged)
                helperToolConnection?.remoteObjectInterface = NSXPCInterface.init(with: NetworkHelperProtocol.self)
                helperToolConnection?.invalidationHandler = {() -> Void in
                    NSLog("connection invalid")
                    self.lock.lock()
                    self.helperToolConnection?.invalidationHandler = nil
                    self.helperToolConnection = nil
                    if(self.installHelper()){
                        NSLog("reinstall helper success")
                    }else{
                        NSLog("install helper failure")
                    }
                    self.lock.unlock()
                }
                helperToolConnection?.resume()
            }
        }
    }
}
