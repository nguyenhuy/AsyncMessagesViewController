//
//  Messaging.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

typealias MessageDataContentType = Int
let kAMMessageDataContentTypeText = 0
let kAMMessageDataContentTypeNetworkImage = 1

@objc protocol MessageData {
    
    func contentType() -> MessageDataContentType
    
    func content() -> String
    
    func date() -> NSDate
    
    func senderID() -> String
    
    func senderDisplayName() -> String
    
    func senderAvatarURL() -> NSURL
    
}
