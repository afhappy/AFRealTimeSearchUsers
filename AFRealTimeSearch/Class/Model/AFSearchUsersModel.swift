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
            
            // 每个用户language集合，后续需要统计出现次数最多的语言
            var languageArr: [String] = []
            tempResultArray.forEach({ (item) in
                guard let tempItem = item as? [String: Any] else {
                    return
                }
                
                for (key, value) in tempItem {
                    if key == "language" {
                        if value is NSNull {
                            return
                        } else {
                            languageArr.append(value as? String ?? "")
                        }
                    }
                }
            })
            
            guard languageArr.count > 0 else {
                return
            }
            
            // 统计出现次数最多的语言
            let language = mostLanguage(array: languageArr)
            
            if let tempResult = resultBlock {
                tempResult(language)
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
 *      - array: 语言数组
 *  - Returns:
 *      - 用户使用最多的语言
 **/
fileprivate func mostLanguage(array: [String]?) -> String? {
    guard let tempLanguageArray = array, tempLanguageArray.count > 0 else {
        return ""
    }
    
    var dic: [String: Int] = [:]
    for v in tempLanguageArray {
        if let value = dic[v] {
            dic[v] = value + 1
        } else {
            dic[v] = 1
        }
    }
    
    var maxCount = 1
    var finalStr = ""
    for (z, j) in dic {
        if maxCount < j {
            maxCount = j
            finalStr = z
        }
    }
    return finalStr
}
