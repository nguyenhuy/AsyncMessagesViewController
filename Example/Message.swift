//
//  Message.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

@objc class Message: MessageData {

    private let _contentType: MessageDataContentType
    private let _content: String
    private let _date: NSDate
    private let sender: User
    
    init(contentType: MessageDataContentType, content: String, date: NSDate, sender: User) {
        _contentType = contentType
        _content = content
        _date = date
        self.sender = sender
    }
    
    func contentType() -> MessageDataContentType {
        return _contentType
    }
    
    func content() -> String {
        return _content
    }
    
    func date() -> NSDate {
        return _date
    }
    
    func senderID() -> String {
        return sender.ID
    }
    
    func senderDisplayName() -> String {
        return sender.name
    }
    
    func senderAvatarURL() -> NSURL {
        return sender.avatarURL
    }
   
}