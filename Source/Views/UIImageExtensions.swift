//
//  UIImageExtensions.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

extension UIImage {
    
    func imageMaskedWith(color: UIColor) -> UIImage {
        let imageRect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -(imageRect.size.height))
        
        CGContextClipToMask(context, imageRect, CGImage)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}