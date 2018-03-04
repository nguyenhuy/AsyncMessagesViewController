//
//  ViewController.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import LoremIpsum

class ViewController: AsyncMessagesViewController {

    private let users: [User]
    private var currentUser: User? {
        return users.filter({$0.ID == self.dataSource.currentUserID()}).first
    }
    
    init?() {
        // Assume the default image size is used for message cell nodes
        let avatarImageSize = CGSize(width: kAMMessageCellNodeAvatarImageSize, height: kAMMessageCellNodeAvatarImageSize)
        users = (0..<5).map() {
            let avatarURL = LoremIpsum.urlForPlaceholderImage(from: .loremPixel, with: avatarImageSize)
            return User(ID: "user-\($0)", name: LoremIpsum.name(), avatarURL: avatarURL!)
        }
        
        let dataSource = DefaultAsyncMessagesCollectionViewDataSource(currentUserID: users[0].ID)
        let delegate = DefaultAsyncMessagesCollectionViewDelegate()
        super.init(dataSource: dataSource, delegate: delegate)
    }
    
    deinit {
        // Tell ASCollectionView that this object is being deallocated (Issue #4)
        asyncCollectionNode.delegate = nil
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change user", style: .plain, target: self, action: #selector(ViewController.changeCurrentUser))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generateMessages()
    }
    
    override func didPressRightButton(_ sender: Any?) {
        if let user = currentUser {
            let message = Message(
                contentType: kAMMessageDataContentTypeText,
                content: textView.text,
                date: Date(),
                sender: user)
            dataSource.collectionNode(collectionNode: asyncCollectionNode, insertMessages: [message]) {completed in
                self.scrollCollectionViewToBottom()
            }
        }
        super.didPressRightButton(sender)
    }

    private func generateMessages() {
        var messages = [Message]()
        for i in 0..<200 {
            let isTextMessage = arc4random_uniform(4) <= 2 // 75%
            let contentType = isTextMessage ? kAMMessageDataContentTypeText : kAMMessageDataContentTypeNetworkImage
            let content = isTextMessage
                ? LoremIpsum.words(withNumber: Int(arc4random_uniform(100)) + 1) as String
                : LoremIpsum.urlForPlaceholderImage(from: .loremPixel, with: CGSize(width: 200, height: 200)).absoluteString

            let sender = users[Int(arc4random_uniform(UInt32(users.count)))]
            
            let previousMessage: Message? = (i > 0) ? messages[i - 1] : nil
            let hasSameSender = (previousMessage != nil)
                ? (sender.ID == previousMessage!.senderID())
                : false
            let date = hasSameSender ? previousMessage!.date().addingTimeInterval(5) : LoremIpsum.date() as Date
            
            let message = Message(
                contentType: contentType,
                content: content,
                date: date,
                sender: sender)
            messages.append(message)
        }
        dataSource.collectionNode(collectionNode: asyncCollectionNode, insertMessages: messages, completion: nil)
    }
    
    @objc func changeCurrentUser() {
        let otherUsers = users.filter({$0.ID != self.dataSource.currentUserID()})
        let newUser = otherUsers[Int(arc4random_uniform(UInt32(otherUsers.count)))]
        dataSource.collectionNode(collectionNode: asyncCollectionNode, updateCurrentUserID: newUser.ID)
    }
}

