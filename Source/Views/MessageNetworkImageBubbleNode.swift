//
//  MessageNetworkImageBubbleNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 27/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import AsyncDisplayKit

open class MessageNetworkImageBubbleNodeFactory: MessageBubbleNodeFactory {

    public init(){
    }

    open func build(message: MessageData, isOutgoing: Bool, bubbleImage: UIImage) -> ASDisplayNode {
        let url = URL(string: message.content())
        return MessageNetworkImageBubbleNode(url: url, bubbleImage: bubbleImage)
    }
    
}

open class MessageNetworkImageBubbleNode: ASNetworkImageNode {
    private let minSize: CGSize
    private let bubbleImage: UIImage
    
    public init(url: URL?, bubbleImage: UIImage, minSize: CGSize = CGSize(width: 210, height: 150)) {
        self.minSize = minSize
        self.bubbleImage = bubbleImage
        super.init(cache: nil, downloader: ASBasicImageDownloader.shared())

        self.url = url
    }
    
    open override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        return CGSize(width: min(constrainedSize.width, minSize.width), height: min(constrainedSize.height, minSize.height))
    }
    
    open override func didLoad() {
        super.didLoad()
        let mask = UIImageView(image: bubbleImage)
        mask.frame.size = calculatedSize
        view.layer.mask = mask.layer
    }
    
}
