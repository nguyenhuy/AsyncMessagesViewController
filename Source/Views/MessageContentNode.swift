//
//  MessageContentNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 13/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

let kAMMessageCellNodeAvatarImageSize: CGFloat = 34
private let kBubbleNodeXOffset: CGFloat = 2

class MessageContentNode: ASDisplayNode {
    
    private let isOutgoing: Bool
    private let bubbleNode: ASDisplayNode
    let avatarImageSize: CGFloat
    private let avatarImageNode: ASNetworkImageNode?

    init(isOutgoing: Bool, avatarURL: NSURL?, avatarImageSize: CGFloat, bubbleNode: ASDisplayNode) {
        self.isOutgoing = isOutgoing
        self.bubbleNode = bubbleNode
        self.avatarImageSize = avatarImageSize
        avatarImageNode = avatarImageSize > 0 ? ASNetworkImageNode() : nil
        super.init()
        
        assert((avatarImageSize > 0) == (avatarImageNode != nil), "avatarImageNode must be initiated according to avatarImageViewSize.")
        avatarImageNode?.backgroundColor = UIColor.clearColor()
        avatarImageNode?.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        avatarImageNode?.URL = avatarURL

        addSubnode(avatarImageNode)
        addSubnode(bubbleNode)
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let bubbleNodeMeasuredSize = bubbleNode.measure(CGSizeMake(constrainedSize.width - avatarImageSize - kBubbleNodeXOffset, constrainedSize.height))
        let requiredHeight = max(avatarImageSize, bubbleNodeMeasuredSize.height)
        return CGSizeMake(constrainedSize.width, requiredHeight)
    }
    
    override func layout() {
        avatarImageNode?.frame = CGRectMake(
            isOutgoing ? self.calculatedSize.width - avatarImageSize : 0, // Right-aligned if is outgoing
            self.calculatedSize.height - avatarImageSize, // Bottom-aligned
            avatarImageSize,
            avatarImageSize)
        
        var bubbleNodeX = avatarImageSize + kBubbleNodeXOffset
        if isOutgoing {
            bubbleNodeX = self.calculatedSize.width - bubbleNode.calculatedSize.width - bubbleNodeX // Right-aligned
        }
        bubbleNode.frame = CGRectMake(
            bubbleNodeX,
            self.calculatedSize.height - bubbleNode.calculatedSize.height, // Bottom-aligned
            bubbleNode.calculatedSize.width,
            bubbleNode.calculatedSize.height)
    }

}