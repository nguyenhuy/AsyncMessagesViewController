//
//  AsyncMessagesViewController.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 12/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

class AsyncMessagesViewController: SLKTextViewController {

    let dataSource: AsyncMessagesCollectionViewDataSource
    override var collectionView: ASCollectionView {
        return scrollView as! ASCollectionView
    }

    init(dataSource: AsyncMessagesCollectionViewDataSource) {
        self.dataSource = dataSource

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        let asyncCollectionView = ASCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        asyncCollectionView.backgroundColor = UIColor.white
        asyncCollectionView.scrollsToTop = true
        asyncCollectionView.asyncDataSource = dataSource
        
        super.init(scrollView: asyncCollectionView)
        
        isInverted = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, 5, 0)
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets

        super.viewWillLayoutSubviews()
    }
    
    func scrollCollectionViewToBottom() {
        let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        if numberOfItems > 0 {
            let lastItemIndexPath = IndexPath(item: numberOfItems - 1, section: 0)
            collectionView.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
        }
    }
    
}
