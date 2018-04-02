//
//  MessageBubbleNodeFactory.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 07/03/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import UIKit
import AsyncDisplayKit

public protocol MessageBubbleNodeFactory {
    
    func build(message: MessageData, isOutgoing: Bool, bubbleImage: UIImage) -> ASDisplayNode
    
}
