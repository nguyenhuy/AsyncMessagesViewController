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
    /// Messages collection view. Called 'asyncCollectionView' because SLKTextViewController reserves 'collectionView' name.
    let asyncCollectionView: ASCollectionView

    init(dataSource: AsyncMessagesCollectionViewDataSource = DefaultAsyncMessagesCollectionViewDataSource()) {
        self.dataSource = dataSource

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        //TODO: consider enabling asyncDataFetching
        asyncCollectionView = ASCollectionView(frame: CGRectZero, collectionViewLayout: layout, asyncDataFetching: false)
        
        super.init(scrollView: asyncCollectionView)

        asyncCollectionView.backgroundColor = UIColor.whiteColor()
        asyncCollectionView.scrollsToTop = true
        asyncCollectionView.asyncDataSource = dataSource
        
        inverted = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, 5, 0)
        asyncCollectionView.contentInset = insets
        asyncCollectionView.scrollIndicatorInsets = insets

        super.viewWillLayoutSubviews()
    }
    
    func scrollCollectionViewToBottom() {
        let lastItemIndex = dataSource.collectionView(asyncCollectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndexPath = NSIndexPath(forItem: lastItemIndex, inSection: 0)
        asyncCollectionView.scrollToItemAtIndexPath(lastItemIndexPath, atScrollPosition: .Bottom, animated: true)
    }
    
}