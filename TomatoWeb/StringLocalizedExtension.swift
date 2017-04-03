//
//  StringLocalizedExtension.swift
//  TomatoWeb
//
//  Created by Lookis on 03/04/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
