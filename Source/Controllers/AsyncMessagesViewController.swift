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

class AsyncMessagesViewController: SLKTextViewController {

    let dataSource: AsyncMessagesCollectionViewDataSource
    let asyncCollectionNode: ASCollectionNode
    override var collectionView: ASCollectionView {
        return scrollView as! ASCollectionView
    }
    init?(dataSource: AsyncMessagesCollectionViewDataSource) {
        self.dataSource = dataSource

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        asyncCollectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
        let asyncCollectionView = asyncCollectionNode.view
        
        asyncCollectionView.backgroundColor = UIColor.white
        asyncCollectionView.scrollsToTop = true
        asyncCollectionNode.dataSource = dataSource
        
        super.init(scrollView: asyncCollectionView)
        
        isInverted = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, 5, 0)
        asyncCollectionNode.contentInset = insets
        collectionView.scrollIndicatorInsets = insets

        super.viewWillLayoutSubviews()
    }
    
    func scrollCollectionViewToBottom() {
        let numberOfItems = dataSource.collectionNode!(asyncCollectionNode, numberOfItemsInSection: 0)
        if numberOfItems > 0 {
            let lastItemIndexPath = IndexPath(item: numberOfItems - 1, section: 0)
            asyncCollectionNode.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
        }
    }
    
}
