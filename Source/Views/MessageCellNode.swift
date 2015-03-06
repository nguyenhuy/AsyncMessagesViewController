//
//  MessageCellNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 12/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

let kAMMessageCellNodeTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]
let kAMMessageCellNodeContentTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(12)]
let kAMMessageCellNodeBottomTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(11)]

private let kContentHorizontalInset: CGFloat = 4
private let kContentVerticalInset: CGFloat = 1

class MessageCellNode: ASCellNode {
    
    private let isOutgoing: Bool
    private let topTextNode: ASTextNode?
    private let contentTopTextNode: ASTextNode?
    private let bottomTextNode: ASTextNode?
    private let contentNode: MessageContentNode

    private var contentTopTextNodeXOffset: CGFloat {
        return contentNode.avatarImageSize > 0 ? 56 : 11
    }
    
    init(isOutgoing: Bool, topText: NSAttributedString?, contentTopText: NSAttributedString?, bottomText: NSAttributedString?, senderAvatarURL: NSURL?, senderAvatarImageSize: CGFloat, bubbleNode: ASDisplayNode) {
        self.isOutgoing = isOutgoing
        contentNode = MessageContentNode(isOutgoing: isOutgoing, avatarURL: senderAvatarURL, avatarImageSize: senderAvatarImageSize, bubbleNode: bubbleNode)
        super.init()

        if let text = topText {
            let node = ASTextNode()
            node.layerBacked = true
            node.attributedString = text
            self.addSubnode(node)
            topTextNode = node
        }

        if let text = contentTopText {
            let node = ASTextNode()
            node.layerBacked = true
            node.attributedString = text
            self.addSubnode(node)
            contentTopTextNode = node
        }

        addSubnode(contentNode)
        
        if let text = bottomText {
            let node = ASTextNode()
            node.layerBacked = true
            node.attributedString = text
            self.addSubnode(node)
            bottomTextNode = node
        }

        selectionStyle = .None
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let pairs: [(ASDisplayNode?, CGFloat)] = [(topTextNode, 0), (contentTopTextNode, contentTopTextNodeXOffset), (contentNode, 0), (bottomTextNode, 0)]
        var requiredHeight: CGFloat = 0
        for (optionalNode, xOffset) in pairs {
            if let node = optionalNode {
                let measuredSize = node.measure(CGSizeMake(constrainedSize.width - xOffset - 2 * kContentHorizontalInset, constrainedSize.height))
                requiredHeight += measuredSize.height
            }
        }
        return CGSizeMake(constrainedSize.width, requiredHeight + 2 * kContentVerticalInset)
    }
    
    override func layout() {
        let topTextNodeXOffset = (self.calculatedSize.width - (topTextNode?.calculatedSize.width ?? 0)) / 2 - kContentHorizontalInset // topTextNode is center-aligned
        let pairs: [(ASDisplayNode?, CGFloat)] = [(topTextNode, topTextNodeXOffset), (contentTopTextNode, contentTopTextNodeXOffset), (contentNode, 0), (bottomTextNode, 0)]
        var y: CGFloat = kContentVerticalInset
        for (optionalNode, xOffset) in pairs {
            if let node = optionalNode {
                var x = kContentHorizontalInset + xOffset
                if isOutgoing {
                    x = self.calculatedSize.width - node.calculatedSize.width - x // Right-aligned
                }
                node.frame = CGRectMake(x, y, node.calculatedSize.width, node.calculatedSize.height)
                y = node.frame.maxY
            }
        }
    }
    
}