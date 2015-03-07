//
//  MessageTextBubbleNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 13/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

private let kAMMessageTextBubbleNodeIncomingTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(14)]
private let kAMMessageTextBubbleNodeOutgoingTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(14)]
private let kTextNodeXOffset: CGFloat = 6
private let kTextNodeInset: CGFloat = 12
private let kTextNodeMinWidth: CGFloat = 15

class MessageTextBubbleNodeFactory: MessageBubbleNodeFactory {
    
    func build(message: MessageData, isOutgoing: Bool, bubbleImage: UIImage) -> ASDisplayNode {
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
        placeholderColor = UIColor.clearColor()
        layerBacked = true
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let size = super.calculateSizeThatFits(constrainedSize)
        return CGSize(width: max(size.width, kTextNodeMinWidth), height: size.height)
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
        textNode.attributedString = text
        
        super.init()
        
        addSubnode(bubbleImageNode)
        addSubnode(textNode)
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let textNodeHorizontalGap = kTextNodeXOffset + 2 * kTextNodeInset
        let textNodeMeasuredSize = textNode.measure(CGSizeMake(constrainedSize.width - textNodeHorizontalGap, constrainedSize.height))
        return CGSizeMake(
            textNodeMeasuredSize.width + textNodeHorizontalGap, // Wrap textNode's width
            textNodeMeasuredSize.height + 2 * kTextNodeInset)
    }
    
    override func layout() {
        bubbleImageNode.frame = CGRectMake(0, 0, calculatedSize.width, calculatedSize.height)
        
        var textNodeX = kTextNodeXOffset + kTextNodeInset
        if isOutgoing {
            textNodeX = self.calculatedSize.width - textNode.calculatedSize.width - textNodeX //Right-aligned
        }
        textNode.frame = CGRectMake(textNodeX, kTextNodeInset, textNode.calculatedSize.width, textNode.calculatedSize.height)
    }
    
}
