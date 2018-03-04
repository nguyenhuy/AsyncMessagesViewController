//
//  MessageTimestampFormatter.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 14/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import UIKit

open class MessageTimestampFormatter {
    
    private let dateFormatter: DateFormatter
    private let dateTextAttributes: [NSAttributedStringKey: AnyObject]
    private let timeTextAttributes: [NSAttributedStringKey: AnyObject]
    
    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.doesRelativeDateFormatting = true

        let color = UIColor.lightGray

        dateTextAttributes = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: color
        ]
        
        timeTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: color
        ]
    }

    open func attributedTimestamp(date: Date) -> NSAttributedString {
        let relativeDate = relativeDateString(date: date)
        let time = timeString(date: date)
        let timestamp = NSMutableAttributedString(string: relativeDate, attributes: dateTextAttributes)
        timestamp.append(NSAttributedString(string: " "))
        timestamp.append(NSAttributedString(string: time, attributes: timeTextAttributes))
        return timestamp
    }
    
    private func timeString(date: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    private func relativeDateString(date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
}
