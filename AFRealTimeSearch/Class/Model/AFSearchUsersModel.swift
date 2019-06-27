//
//  AFSearchUsersModel.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/22.
//  Copyright © 2019 af. All rights reserved.
//

import Foundation
import HandyJSON

public typealias resultBlock = (_ value: String?) -> ()

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
        dealMostLanguage(userName: login) { (result) in
            self.userLanguage = result
//            通知发送处理后的语言
            NotificationCenter.default.post(name: Notification.Name.Task.UserUseMostLanguage, object: nil)
            
        }
    }
    
    required init() {
        
    }
}

/**
 *  MARK: - 处理用户使用最多的语言
 *
 *  - Paramters:
 *      - userName: 用户名
 *      - result: 闭包，返回最终的语言
 **/
fileprivate func dealMostLanguage(userName: String?, result resultBlock: resultBlock? = nil ) {
    // 判断用户名
    guard let tempUserName = userName, tempUserName != "" else {
        return
    }
    
    // 请求数据
    let queue = DispatchQueue.init(label: "getCommonUseLanguage")
    queue.async {
        let urlStrLanguage: String = api_getUserRepos + tempUserName + "/repos?client_id=bd2eebc709ab4c567100&client_secret=006967600a3b28cff268d8a8251c3b3a948f89b0"
        
        AFNetWorking.manager.getRequest(urlStrLanguage, success: { (result) in
            guard let tempResult = result else {
                return
            }
            let resultArray: [Any]? = tempResult as? [Any]
            guard let tempResultArray = resultArray else {
                return
            }
            
//            计算用户使用最多的语言
            let commonLanguage = mostLanguage(array: tempResultArray)
            if let tempResult = resultBlock {
                tempResult(commonLanguage)
            }
            
        }) { (error) in
            print(error as Any)
        }
    }
}

/**
 *  MARK: - 统计用户使用最多的语言
 *
 *  - Paramters:
 *      - array: 用户的repos
 *  - Returns:
 *      - 用户使用最多的语言
 **/
fileprivate func mostLanguage(array: [Any]?) -> String? {
    guard let tempRepos = array, tempRepos.count > 0 else {
        return ""
    }
    
    // 需要统计出现次数最多的语言，使用字典，key为语言，value为语言出现的次数
    var dic: [String: Int] = [:]
    tempRepos.forEach({ (item) in
        guard let tempItem = item as? [String: Any] else {
            return
        }
        for (key, value) in tempItem {
            if key == "language" {
                if value is NSNull {
                    return
                } else {
                    let language: String = value as! String
                    if let languageNum = dic[language] {
                        dic[language] = languageNum + 1
                    }else{
                        dic[language] = 1
                    }
                    
                    
                }
            }
        }
    })
    
    // 统计出现次数最多的语言
    guard dic.count > 0 else {
        return ""
    }
    var maxCount = 1
    var finalLanguage = ""
    for (z, j) in dic {
        if maxCount < j {
            maxCount = j
            finalLanguage = z
        }
    }
    return finalLanguage
}
