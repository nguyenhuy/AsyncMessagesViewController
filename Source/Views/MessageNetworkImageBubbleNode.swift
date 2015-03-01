//
//  MessageNetworkImageBubbleNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 27/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

let kAMImageBubbleNodeSize: CGSize = CGSizeMake(210, 150)

class MessageNetworkImageBubbleNode: ASNetworkImageNode {
    private let minSize: CGSize
    private let bubbleImage: UIImage
    
    init(bubbleImage: UIImage, URL: NSURL?, minSize: CGSize = kAMImageBubbleNodeSize) {
        self.minSize = minSize
        self.bubbleImage = bubbleImage
        super.init(cache: nil, downloader: ASBasicImageDownloader())

        self.URL = URL
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        return CGSizeMake(min(constrainedSize.width, minSize.width), min(constrainedSize.height, minSize.height))
    }
    
    override func didLoad() {
        super.didLoad()
        let mask = UIImageView(image: bubbleImage)
        mask.frame.size = calculatedSize
        view.layer.mask = mask.layer
    }
    
}