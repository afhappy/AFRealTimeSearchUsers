//
//  AFSearchUsersModel.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/22.
//  Copyright © 2019 af. All rights reserved.
//

import Foundation
import HandyJSON

class AFSearchUsersModel: HandyJSON {
    // 用户信息
    var items: [UsersModel]?
    
    required init() {
        
    }
}

class UsersModel: HandyJSON {
    // 用户名
    var login: String?
    
    // 用户头像
    var avatar_url: String?
    
    // 用户语言
    var userLanguage: String?
    
    // 获取每个用户对应的language
    func didFinishMapping() {
        let searchUsersViewModel = AFSearchUsersViewModel()
        searchUsersViewModel.dealMostLanguage(userName: login) { (result) in
            self.userLanguage = result
//            通知发送处理后的语言
            NotificationCenter.default.post(name: Notification.Name.Task.UserUseMostLanguage, object: nil)
            
        }
    }
    
    required init() {
        
    }
}
