//
//  AsyncMessagesCollectionViewDataSource.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 26/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

//TODO revise method name to adhere to Swift 3 convention
public protocol AsyncMessagesCollectionViewDataSource: ASCollectionDataSource {
    
    func currentUserID() -> String?
    
    func collectionNode(collectionNode: ASCollectionNode, updateCurrentUserID newUserID: String?)
    
    func collectionNode(collectionNode: ASCollectionNode, messageForItemAtIndexPath indexPath: IndexPath) -> MessageData
    
    func collectionNode(collectionNode: ASCollectionNode, insertMessages newMessages: [MessageData], completion: ((Bool) -> ())?)
    
    func collectionNode(collectionNode: ASCollectionNode, deleteMessagesAtIndexPaths indexPaths: [IndexPath], completion: ((Bool) -> ())?)
    
}
