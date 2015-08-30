//
//  MessageTimestampFormatter.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 14/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

class MessageTimestampFormatter {
    
    private let dateFormatter: NSDateFormatter
    private let dateTextAttributes: [String: AnyObject]
    private let timeTextAttributes: [String: AnyObject]
    
    init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.doesRelativeDateFormatting = true

        let color = UIColor.lightGrayColor()

        dateTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(12),
            NSForegroundColorAttributeName: color
        ]
        
        timeTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(12),
            NSForegroundColorAttributeName: color
        ]
    }

    func attributedTimestamp(date: NSDate) -> NSAttributedString {
        let relativeDate = relativeDateString(date)
        let time = timeString(date)
        let timestamp = NSMutableAttributedString(string: relativeDate, attributes: dateTextAttributes)
        timestamp.appendAttributedString(NSAttributedString(string: " "))
        timestamp.appendAttributedString(NSAttributedString(string: time, attributes: timeTextAttributes))
        return timestamp
    }
    
    private func timeString(date: NSDate) -> String {
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }

    private func relativeDateString(date: NSDate) -> String {
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter.stringFromDate(date)
    }
    
}