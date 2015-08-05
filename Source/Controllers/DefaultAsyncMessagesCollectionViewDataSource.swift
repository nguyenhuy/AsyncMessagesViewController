//
//  DefaultAsyncMessagesCollectionViewDataSource.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

//TODO: Make AsyncMessagesCollectionViewDataSource's methods thread-safe.
class DefaultAsyncMessagesCollectionViewDataSource: NSObject, AsyncMessagesCollectionViewDataSource {
    
    private let nodeMetadataFactory: MessageCellNodeMetadataFactory
    private let bubbleImageProvider: MessageBubbleImageProvider
    private let timestampFormatter: MessageTimestampFormatter
    private let bubbleNodeFactories: [MessageDataContentType: MessageBubbleNodeFactory]
    private var _currentUserID: String?
    /// Managed messages. They are sorted in ascending order of their date. The order is enforced during insertion.
    private var messages: [MessageData]
    private var nodeMetadatas: [MessageCellNodeMetadata]
    
    init(currentUserID: String? = nil,
        nodeMetadataFactory: MessageCellNodeMetadataFactory = MessageCellNodeMetadataFactory(),
        bubbleImageProvider: MessageBubbleImageProvider = MessageBubbleImageProvider(),
        timestampFormatter: MessageTimestampFormatter = MessageTimestampFormatter(),
        bubbleNodeFactories: [MessageDataContentType: MessageBubbleNodeFactory] = [
            kAMMessageDataContentTypeText: MessageTextBubbleNodeFactory(),
            kAMMessageDataContentTypeNetworkImage: MessageNetworkImageBubbleNodeFactory()
        ]) {
            _currentUserID = currentUserID
            self.nodeMetadataFactory = nodeMetadataFactory
            self.bubbleImageProvider = bubbleImageProvider
            self.timestampFormatter = timestampFormatter
            self.bubbleNodeFactories = bubbleNodeFactories
            messages = []
            nodeMetadatas = []
    }

    //MARK: ASCollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        assert(nodeMetadatas.count == messages.count, "Node metadata is required for each message.")
        return messages.count
    }

    func collectionView(collectionView: ASCollectionView!, nodeForItemAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let message = self.collectionView(collectionView, messageForItemAtIndexPath: indexPath)
        let metadata = nodeMetadatas[indexPath.item]
        let isOutgoing = metadata.isOutgoing

        let senderAvatarURL: NSURL? = metadata.showsSenderAvatar ? message.senderAvatarURL() : nil
        let messageDate: NSAttributedString? = metadata.showsDate
            ? timestampFormatter.attributedTimestamp(message.date())
            : nil
        let senderDisplayName: NSAttributedString? = metadata.showsSenderName
            ? NSAttributedString(string: message.senderDisplayName(), attributes: kAMMessageCellNodeContentTopTextAttributes)
            : nil
        
        let bubbleImage = bubbleImageProvider.bubbleImage(isOutgoing, hasTail: metadata.showsTailForBubbleImage)
        assert(bubbleNodeFactories.indexForKey(message.contentType()) != nil, "No bubble node factory for content type: \(message.contentType())")
        let bubbleNode = bubbleNodeFactories[message.contentType()]!.build(message, isOutgoing: isOutgoing, bubbleImage: bubbleImage)
        
        let cellNode = MessageCellNode(
            isOutgoing: isOutgoing,
            topText: messageDate,
            contentTopText: senderDisplayName,
            bottomText: nil,
            senderAvatarURL: senderAvatarURL,
            senderAvatarImageSize: kAMMessageCellNodeAvatarImageSize,
            bubbleNode: bubbleNode)
        
        return cellNode
    }
  
    func collectionView(collectionView: ASCollectionView!, constrainedSizeForNodeAtIndexPath indexPath: NSIndexPath!) -> ASSizeRange {
        let width = collectionView.bounds.width;
        // Assume horizontal scroll directions
        return ASSizeRangeMake(CGSizeMake(width, 0), CGSizeMake(width, CGFloat.max))
    }

    //MARK: AsyncMessagesCollectionViewDataSource methods
    func currentUserID() -> String? {
        return _currentUserID
    }
    
    func collectionView(collectionView: ASCollectionView, updateCurrentUserID newUserID: String?) {
        if newUserID == _currentUserID {
            return
        }
        
        _currentUserID = newUserID
        
        let outdatedMetadatas = nodeMetadatas
        let updatedMetadatas = nodeMetadataFactory.buildMetadatas(messages, currentUserID: _currentUserID)
        nodeMetadatas = updatedMetadatas
        
        let reloadIndicies = Array<MessageCellNodeMetadata>.computeDiff(outdatedMetadatas, rhs: updatedMetadatas)
        collectionView.reloadItemsAtIndexPaths(NSIndexPath.createIndexPaths(0, items: reloadIndicies))
    }

    func collectionView(collectionView: ASCollectionView, messageForItemAtIndexPath indexPath: NSIndexPath) -> MessageData {
        return messages[indexPath.item]
    }
    
    func collectionView(collectionView: ASCollectionView, insertMessages newMessages: [MessageData], completion: ((Bool) -> ())?) {
        
        if newMessages.isEmpty {
            return
        }
        
        var insertedIndices = [Int]()
        // Sort new messages to make sure insertion starts from the begining of the array and previous insertion indicies are always valid.
        let isOrderedBefore: (MessageData, MessageData) -> Bool = {
            $0.date().compare($1.date()) == NSComparisonResult.OrderedAscending
        }
        for newMessage in newMessages.sort(isOrderedBefore) {
            insertedIndices.append(messages.insert(newMessage, isOrderedBefore: isOrderedBefore))
        }
        
        var outdatedNodeMetadatas = nodeMetadatas
        let updatedNodeMetadatas = nodeMetadataFactory.buildMetadatas(messages, currentUserID: _currentUserID)
        nodeMetadatas = updatedNodeMetadatas

        // Copy metadata of new messages to the outdated metadata array. Thus outdated and updated arrays will have the same size and computing diff between them will be much easier.
        for insertedIndex in insertedIndices {
            outdatedNodeMetadatas.insert(updatedNodeMetadatas[insertedIndex], atIndex: insertedIndex)
        }
        let reloadIndicies = Array<MessageCellNodeMetadata>.computeDiff(outdatedNodeMetadatas, rhs: updatedNodeMetadatas)
        
        collectionView.performBatchUpdates(
            {
                collectionView.insertItemsAtIndexPaths(NSIndexPath.createIndexPaths(0, items: insertedIndices))
                if !reloadIndicies.isEmpty {
                    collectionView.reloadItemsAtIndexPaths(NSIndexPath.createIndexPaths(0, items: reloadIndicies))
                }
            },
            completion: completion)
    }
  
  
    func collectionView(collectionView: ASCollectionView, deleteMessagesAtIndexPaths indexPaths: [NSIndexPath], completion: ((Bool) -> ())?) {
        if indexPaths.isEmpty {
            return
        }

        var outdatedNodesMetadata = nodeMetadatas
        // Sort indicies in descending order to make sure deletion starts from the end of the array and remaining indicies are always valid.
        let isOrderedBefore: (NSIndexPath, NSIndexPath) -> Bool = {
            $0.compare($1) == NSComparisonResult.OrderedDescending
        }
        let sortedIndexPaths = indexPaths.sort(isOrderedBefore)
        for indexPath in sortedIndexPaths {
            messages.removeAtIndex(indexPath.item)
            outdatedNodesMetadata.removeAtIndex(indexPath.item)
        }

        let updatedNodeMetadatas = nodeMetadataFactory.buildMetadatas(messages, currentUserID: _currentUserID)
        nodeMetadatas = updatedNodeMetadatas

        let reloadIndicies = Array<MessageCellNodeMetadata>.computeDiff(outdatedNodesMetadata, rhs: updatedNodeMetadatas)
        
        collectionView.performBatchUpdates(
            {
                collectionView.deleteItemsAtIndexPaths(sortedIndexPaths)
                if !reloadIndicies.isEmpty {
                    collectionView.reloadItemsAtIndexPaths(NSIndexPath.createIndexPaths(0, items: reloadIndicies))
                }
            },
            completion: completion)
    }
    
}

//MARK: Utils
private extension Array {

    mutating func insert(newElement: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        let index = insertionIndex(newElement, isOrderedBefore: isOrderedBefore)
        insert(newElement, atIndex: index)
        return index
    }
    
    func insertionIndex(newElement: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = count - 1
        
        while (low <= high) {
            let mid = low + ((high - low) / 2)
            let midElement = self[mid]
            
            if isOrderedBefore(midElement, newElement) {
                low = mid + 1
            } else if isOrderedBefore(newElement, midElement) {
                high = mid - 1
            } else {
                return mid
            }
        }
        return low
    }
    
    static func computeDiff<T where T: Equatable>(lhs: Array<T>, rhs: Array<T>) -> [Int] {
        assert(lhs.count == rhs.count, "Expect arrays with the same size.")
        var diffIndices = [Int]()
        for i in 0..<lhs.count {
            if lhs[i] != rhs[i] {
                diffIndices.append(i)
            }
        }
        return diffIndices
    }
    
}

private extension NSIndexPath {
    
    class func createIndexPaths(section: Int, items: [Int]) -> [NSIndexPath] {
        return items.map() {
            NSIndexPath(forItem: $0, inSection: section)
        }
    }
    
}
