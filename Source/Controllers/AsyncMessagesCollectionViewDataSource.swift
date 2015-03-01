//
//  AsyncMessagesCollectionViewDataSource.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 26/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

protocol AsyncMessagesCollectionViewDataSource: ASCollectionViewDataSource {
    
    func currentUserID() -> String?
    
    func collectionView(collectionView: ASCollectionView, updateCurrentUserID newUserID: String?)
    
    func collectionView(collectionView: ASCollectionView, messageForItemAtIndexPath indexPath: NSIndexPath) -> MessageData
    
    func collectionView(collectionView: ASCollectionView, insertMessages newMessages: [MessageData], completion: ((Bool) -> ())?)
    
    func collectionView(collectionView: ASCollectionView, deleteMessagesAtIndexPaths indexPaths: [NSIndexPath], completion: ((Bool) -> ())?)
    
}
