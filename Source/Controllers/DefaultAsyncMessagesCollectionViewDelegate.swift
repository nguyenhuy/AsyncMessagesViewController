//
//  DefaultAsyncMessageDelegate.swift
//  Example
//
//  Created by Tien Nguyen on 3/4/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import AsyncDisplayKit

class DefaultAsyncMessagesCollectionViewDelegate: NSObject, ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width = collectionNode.bounds.width;
        return ASSizeRangeMake(CGSize(width: width, height: 0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
}
