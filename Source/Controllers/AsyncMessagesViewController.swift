//
//  AsyncMessagesViewController.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 12/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SlackTextViewController

open class AsyncMessagesViewController: SLKTextViewController {

    open let dataSource: AsyncMessagesCollectionViewDataSource
    open let delegate: ASCollectionDelegate
    open let asyncCollectionNode: ASCollectionNode
    override open var collectionView: ASCollectionView {
        return scrollView as! ASCollectionView
    }

    public init?(dataSource: AsyncMessagesCollectionViewDataSource, delegate: ASCollectionDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        asyncCollectionNode = ASCollectionNode(collectionViewLayout: layout)
        let asyncCollectionView = asyncCollectionNode.view
        
        asyncCollectionView.backgroundColor = UIColor.white
        asyncCollectionView.scrollsToTop = true
        asyncCollectionNode.dataSource = dataSource
        asyncCollectionNode.delegate = delegate
        super.init(scrollView: asyncCollectionView)
        
        isInverted = false
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewWillLayoutSubviews() {
        let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, 5, 0)
        asyncCollectionNode.contentInset = insets
        collectionView.scrollIndicatorInsets = insets

        super.viewWillLayoutSubviews()
    }
    
    open func scrollCollectionViewToBottom() {
        let numberOfItems = dataSource.collectionNode!(asyncCollectionNode, numberOfItemsInSection: 0)
        if numberOfItems > 0 {
            let lastItemIndexPath = IndexPath(item: numberOfItems - 1, section: 0)
            asyncCollectionNode.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
        }
    }
    
}
