//
//  MessageBubbleImageProvider.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 8/5/14, inspired by JSQMessagesBubbleImageFactory
//  Copyright (c) 2014 Huy Nguyen. All rights reserved.
//

import Foundation

private struct MessageProperties: Hashable {
    let isOutgoing: Bool
    let hasTail: Bool
    
    var hashValue: Int {
        return (31 &* isOutgoing.hashValue) &+ hasTail.hashValue
    }
}

private func ==(lhs: MessageProperties, rhs: MessageProperties) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

private let kDefaultIncomingColor = UIColor(red: 239 / 255, green: 237 / 255, blue: 237 / 255, alpha: 1)
private let kDefaultOutgoingColor = UIColor(red: 17 / 255, green: 107 / 255, blue: 254 / 255, alpha: 1)

class MessageBubbleImageProvider {
    
    private let outgoingColor: UIColor
    private let incomingColor: UIColor
    private var imageCache = [MessageProperties: UIImage]()
    
    init(incomingColor: UIColor = kDefaultIncomingColor, outgoingColor: UIColor = kDefaultOutgoingColor) {
        self.incomingColor = incomingColor
        self.outgoingColor = outgoingColor
    }
    
    func bubbleImage(isOutgoing: Bool, hasTail: Bool) -> UIImage {
        let properties = MessageProperties(isOutgoing: isOutgoing, hasTail: hasTail)
        return bubbleImage(properties)
    }
    
    private func bubbleImage(properties: MessageProperties) -> UIImage {
        if let image = imageCache[properties] {
            return image
        }
        
        let image = buildBubbleImage(properties)
        imageCache[properties] = image
        return image
    }
    
    private func buildBubbleImage(properties: MessageProperties) -> UIImage {
        let imageName = "bubble" + (properties.isOutgoing ? "_outgoing" : "_incoming") + (properties.hasTail ? "" : "_tailless")
        let bubble = UIImage(named: imageName)!
        
        var normalBubble = bubble.imageMaskedWith(properties.isOutgoing ? outgoingColor : incomingColor)
        
        // make image stretchable from center point
        let center = CGPointMake(bubble.size.width / 2.0, bubble.size.height / 2.0)
        let capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
        
        normalBubble = MessageBubbleImageProvider.stretchableImage(normalBubble, capInsets: capInsets)
        return normalBubble
    }
    
    private class func stretchableImage(source: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        return source.resizableImageWithCapInsets(capInsets, resizingMode: .Stretch)
    }
    
}
