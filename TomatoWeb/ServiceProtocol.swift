//
//  ServiceProtocol.swift
//  TomatoWeb
//
//  Created by Lookis on 30/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation

public protocol ServiceProtocol {
    init()
    //make soft link to system library
    func setupService()
    
    func generateLaunchdPlist() -> NSMutableDictionary!
    
}
