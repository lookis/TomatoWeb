//
//  HorizontalCenteredSecureTextFieldCell.swift
//  TomatoNetwork
//
//  Created by Lookis on 12/05/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

import Cocoa

class HorizontalCenteredSecureTextFieldCell: NSSecureTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        var newRect = super.drawingRect(forBounds: rect);
        let textSize = self.cellSize(forBounds: rect);
        let heightDelta = newRect.size.height - textSize.height;
        if (heightDelta > 0){
            newRect.size.height -= heightDelta;
            newRect.origin.y += (heightDelta / 2);
            newRect.size.width -= heightDelta;
            newRect.origin.x += (heightDelta / 2);
        }
        return newRect;
    }
}
