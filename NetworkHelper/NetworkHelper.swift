//
//  NetworkHelper.swift
//  TomatoWeb
//
//  Created by Lookis on 01/04/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

let kHelperToolMachServiceName = "me.lookis.tomato.NetworkHelper"

import Foundation
import SystemConfiguration

public class NetworkHelper: NSObject, NSXPCListenerDelegate, NetworkHelperProtocol{
    
    var listener:NSXPCListener? = nil
    
    public override init(){
        super.init()
        print("helper init")
        listener = NSXPCListener.init(machServiceName: kHelperToolMachServiceName)
        listener?.delegate = self
    }
    
    public func run(){
        listener?.resume()
        RunLoop.current.run()
    }
    
    public func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool{
        newConnection.exportedInterface = NSXPCInterface.init(with: NetworkHelperProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()
        return true
    }
    
    public func ping(callback: (String) -> Void) {
        callback("pong")
    }
    
    public func clearNetworkSetting() {
        let proxies:Dictionary = [kCFNetworkProxiesHTTPEnable as NSString: 0,
                                  kCFNetworkProxiesHTTPSEnable as NSString: 0,
                                  kCFNetworkProxiesProxyAutoConfigEnable as NSString: 0,
                                  kCFNetworkProxiesSOCKSEnable as NSString: 0,
                                  kCFNetworkProxiesExceptionsList as NSString: ["127.0.0.1", "localhost"]] as [NSString : Any]
        makeChange(proxy: proxies)
    }
    
    public func setAutomaticProxyConfig(address: String!) {
        let proxies:Dictionary = [kCFNetworkProxiesHTTPEnable as NSString: 0,
                                  kCFNetworkProxiesHTTPSEnable as NSString: 0,
                                  kCFNetworkProxiesProxyAutoConfigEnable as NSString: 1,
                                  kCFNetworkProxiesProxyAutoConfigURLString as NSString: address,
                                  kCFNetworkProxiesSOCKSEnable as NSString: 0,
                                  kCFNetworkProxiesExceptionsList as NSString: ["127.0.0.1", "localhost"]] as [NSString : Any]
        makeChange(proxy: proxies)
    }
    
    public func setSocksProxy(host: String!, port:NSNumber!) {
        let proxies:Dictionary = [kCFNetworkProxiesHTTPEnable as NSString: 0,
                                  kCFNetworkProxiesHTTPSEnable as NSString: 0,
                                  kCFNetworkProxiesProxyAutoConfigEnable as NSString: 0,
                                  kCFNetworkProxiesSOCKSEnable as NSString: 1,
                                  kCFNetworkProxiesSOCKSProxy as NSString: host,
                                  kCFNetworkProxiesSOCKSPort as NSString: port,
                                  kCFNetworkProxiesExceptionsList as NSString: ["127.0.0.1", "localhost"]] as [NSString : Any]
        makeChange(proxy: proxies)
    }
    
    func makeChange(proxy: Dictionary<NSString, Any>){
        var authRef:AuthorizationRef? = nil;
        let authFlags:AuthorizationFlags = [.extendRights, .interactionAllowed, .preAuthorize]
        let authErr = AuthorizationCreate(nil, nil, authFlags, &authRef);
        if(authErr == noErr){
            let prefRef = SCPreferencesCreateWithAuthorization(nil, "TomatoWeb" as CFString, nil, authRef);
            let networkSettings = SCPreferencesGetValue(prefRef!, kSCPrefNetworkServices) as? NSDictionary;
            for key in networkSettings!.allKeys {
                let setting:NSDictionary = networkSettings?.object(forKey: key) as! NSDictionary
                let hardware = setting.value(forKeyPath: "Interface.Hardware") as? String
                if (hardware == "AirPort"
                    || hardware == "Wi-Fi"
                    || hardware == "Ethernet") {
                    SCPreferencesPathSetValue(prefRef!, "/\(kSCPrefNetworkServices)/\(key)/\(kSCEntNetProxies)" as CFString
                        , proxy as CFDictionary);
                }
            }
            SCPreferencesCommitChanges(prefRef!)
            SCPreferencesApplyChanges(prefRef!)
            SCPreferencesSynchronize(prefRef!)
        }
        
        AuthorizationFree(authRef!, AuthorizationFlags.init(rawValue: 0));
        
    }
    
    
}
