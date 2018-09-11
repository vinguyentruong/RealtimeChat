//
//  Notification+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/20/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    internal static let OAuthExpiredEvent   = Notification.Name("OAuthExpiredEvent")
    public static let StatusChange  = Notification.Name(rawValue: "statusChange")
    
    internal static let createMessage = Notification.Name("CreateMessage")
    internal static let updateMessage = Notification.Name("UpdateMessage")
    internal static let deleteMessage = Notification.Name("DeleteMessage")
}
