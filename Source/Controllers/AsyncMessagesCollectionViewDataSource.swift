//
//  AsyncMessagesCollectionViewDataSource.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 26/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

//TODO revise method name to adhere to Swift 3 convention
protocol AsyncMessagesCollectionViewDataSource: ASCollectionDataSource {
    
    func currentUserID() -> String?
    
    func collectionView(collectionView: ASCollectionView, updateCurrentUserID newUserID: String?)
    
    func collectionView(collectionView: ASCollectionView, messageForItemAtIndexPath indexPath: IndexPath) -> MessageData
    
    func collectionView(collectionView: ASCollectionView, insertMessages newMessages: [MessageData], completion: ((Bool) -> ())?)
    
    func collectionView(collectionView: ASCollectionView, deleteMessagesAtIndexPaths indexPaths: [IndexPath], completion: ((Bool) -> ())?)
    
}
