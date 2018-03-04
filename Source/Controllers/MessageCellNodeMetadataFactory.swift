//
//  MessageCellMetadataFactory.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

public struct MessageCellNodeMetadata: Hashable {
    let isOutgoing: Bool
    let showsSenderName: Bool
    let showsSenderAvatar: Bool
    let showsTailForBubbleImage: Bool
    let showsDate: Bool
    
    public var hashValue: Int {
        return (24 &* isOutgoing.hashValue) &+ (18 &* showsSenderName.hashValue) &+ (12 &* showsSenderAvatar.hashValue) &+ (6 &* showsTailForBubbleImage.hashValue) &+ showsDate.hashValue
    }
}

public func ==(lhs: MessageCellNodeMetadata, rhs: MessageCellNodeMetadata) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

open class MessageCellNodeMetadataFactory {

    public init(){
    }
    
    open func buildMetadatas(for messages: [MessageData], currentUserID: String?) -> [MessageCellNodeMetadata] {
        var result = [MessageCellNodeMetadata]()
        if messages.isEmpty {
            return result
        }
        
        let showSenderNameFlags = calculateShowSenderNameFlags(for: messages, currentUserID: currentUserID)
        let showSenderAvatarFlags = calculateShowSenderAvatarFlags(for: messages)
        // Bubble image's tail points to sender's avatar. It should be shown only if the avatar is shown.
        let showTailFlags = showSenderAvatarFlags
        let showDateFlags = calculateShowDateFlags(for: messages)
        
        for i in 0..<messages.count {
            let metadata = MessageCellNodeMetadata(
                isOutgoing: (messages[i].senderID() == currentUserID),
                showsSenderName: showSenderNameFlags[i],
                showsSenderAvatar: showSenderAvatarFlags[i],
                showsTailForBubbleImage: showTailFlags[i],
                showsDate: showDateFlags[i]
            )
            result.append(metadata)
        }
        
        return result
    }
    
    /**
        Calculate flags indicate whether sender name should be shown for a given message or not.
        Sender name is shown if an incoming message is the fist one in consecutive ones sent by same sender.
    
        - parameter messages:
        - parameter currentUserID: used to detect outgoing messages.
    
        - returns: flags in the same order as messages param. `true` if sender name should be shown. `false` otherwise.
    */
    private func calculateShowSenderNameFlags(for messages: [MessageData], currentUserID: String?) -> [Bool] {
        var result = Array<Bool>(repeating: false, count: messages.count)
        
        result[0] = true
        
        for i in (1..<messages.count).reversed() {
            let message = messages[i]
            if !message.senderDisplayName().isEmpty {
                let isOutgoing = (message.senderID() == currentUserID)
                let hasSameSenderAsPreviousMessage = message.senderID() == messages[i - 1].senderID()
                result[i] = !isOutgoing && !hasSameSenderAsPreviousMessage
            }
        }
        
        return result
    }

    /*
        Calculate flags indicate whether sender avatar should be shown for a given message or not.
        Sender avatar is shown if a message is the last one in consecutive ones sent by same sender.
    
        :param: messages
    
        :returns: flags in the same order as messages param. `true` if sender avatar should be shown. `false` otherwise.
    */
    private func calculateShowSenderAvatarFlags(for messages: [MessageData]) -> [Bool] {
        var result = Array<Bool>(repeating: false, count: messages.count)
        
        result[messages.count - 1] = true
        
        for i in 0..<(messages.count - 1) {
            let hasSameSenderAsNextMessage = messages[i].senderID() == messages[i + 1].senderID()
            result[i] = !hasSameSenderAsNextMessage
        }
        
        return result
    }
    
    /**
        Calculate flags indicate whether date should be shown for a given message or not.
        Date is shown if a message is the first one in consecutive ones sent within 15 minutes.
    
        - parameter messages:
        
        - returns: flags in the same order as messages param. `true` if date should be shown. `false` otherwise.
    */
    private func calculateShowDateFlags(for messages: [MessageData]) -> [Bool] {
        let dateInterval: Double = 15 * 60 // 15 minutes
        var result = Array<Bool>(repeating: false, count: messages.count)
        
        result[0] = true
        var lastShownDate = messages[0].date()
        
        for i in 1..<messages.count {
            let date = messages[i].date()
            if abs(date.timeIntervalSince(lastShownDate)) >= dateInterval {
                result[i] = true
                lastShownDate = date
            }
        }
        
        return result
    }
    
}
