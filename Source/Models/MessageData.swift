//
//  Messaging.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

public typealias MessageDataContentType = Int
public let kAMMessageDataContentTypeText: MessageDataContentType = 0
public let kAMMessageDataContentTypeNetworkImage: MessageDataContentType = 1

public protocol MessageData {
    
    func contentType() -> MessageDataContentType
    
    func content() -> String
    
    func date() -> Date
    
    func senderID() -> String
    
    func senderDisplayName() -> String
    
    func senderAvatarURL() -> URL
    
}
