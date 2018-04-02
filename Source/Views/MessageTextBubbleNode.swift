//
//  MessageTextBubbleNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 13/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import UIKit
import AsyncDisplayKit

private let kAMMessageTextBubbleNodeIncomingTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
private let kAMMessageTextBubbleNodeOutgoingTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]

open class MessageTextBubbleNodeFactory: MessageBubbleNodeFactory {

    public init(){
    }

    open func build(message: MessageData, isOutgoing: Bool, bubbleImage: UIImage) -> ASDisplayNode {
        let attributes = isOutgoing
            ? kAMMessageTextBubbleNodeOutgoingTextAttributes
            : kAMMessageTextBubbleNodeIncomingTextAttributes
        let text = NSAttributedString(string: message.content(), attributes: attributes)
        return MessageTextBubbleNode(text: text, isOutgoing: isOutgoing, bubbleImage: bubbleImage)
    }
    
}

private class MessageTextNode: ASTextNode {
    
    override init() {
        super.init()
        placeholderColor = UIColor.clear
        isLayerBacked = true
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        let size = super.calculateSizeThatFits(constrainedSize)
        return CGSize(width: max(size.width, 15), height: size.height)
    }
    
}

class MessageTextBubbleNode: ASDisplayNode {

    private let isOutgoing: Bool
    private let bubbleImageNode: ASImageNode
    private let textNode: ASTextNode
    
    init(text: NSAttributedString, isOutgoing: Bool, bubbleImage: UIImage) {
        self.isOutgoing = isOutgoing

        bubbleImageNode = ASImageNode()
        bubbleImageNode.image = bubbleImage

        textNode = MessageTextNode()
        textNode.attributedText = text
        
        super.init()
        
        addSubnode(bubbleImageNode)
        addSubnode(textNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textNodeVerticalOffset = CGFloat(6)
        return ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(
                    12,
                    12 + (isOutgoing ? 0 : textNodeVerticalOffset),
                    12,
                    12 + (isOutgoing ? textNodeVerticalOffset : 0)),
                child: textNode),
            background: bubbleImageNode)
    }
    
}
