//
//  AFNotificationConst.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/22.
//  Copyright © 2019 af. All rights reserved.
//

import Foundation

extension Notification.Name{
    public struct Task{
        public static let SearchUsersKeyword = Notification.Name("org.ReviewIOS_Swift.notification.name.task.searchUsersKeyword")
        public static let UserUseMostLanguage = Notification.Name("org.ReviewIOS_Swift.notification.name.task.useMostLanguage")
    }
}
