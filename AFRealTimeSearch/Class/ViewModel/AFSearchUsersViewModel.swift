//
//  AFSearchUsersViewModel.swift
//  AFRealTimeSearch
//
//  Created by fa on 2019/6/28.
//  Copyright © 2019 af. All rights reserved.
//

import Foundation

class AFSearchUsersViewModel: NSObject {
    
    /**
     *  MARK: - 请求用户数据
     *
     *  - Parameters:
     *      - userName: 用户名
     **/
    public func requestUserData(userName: String?, completion: @escaping ([UsersModel]?)->()) {
        // 判断用户名
        guard let tempUserName = userName, tempUserName != "" else {
            completion(nil)
            return
        }
        
        // 请求数据
        let urlString: String = api_getUserInfo + tempUserName
        
        AFNetWorking.manager.getRequest(urlString, success: { (result) in
            // model
            let dataItem = AFSearchUsersModel.deserialize(from: (result as? [String: Any]))
            guard let tempDataItem = dataItem else {
                completion(nil)
                return
            }
            if let tempItem = tempDataItem.items {
                guard tempItem.count > 0 else {
                    completion(nil)
                    return
                }
                completion(tempItem)
            }
            
        }) { (error) in
            completion(nil)
            print(error as Any)
        }
    }
    
    /**
     *  MARK: - 处理用户使用最多的语言
     *
     *  - Paramters:
     *      - userName: 用户名
     *      - result: 闭包，返回最终的语言
     **/
    public func dealMostLanguage(userName: String?, completion: @escaping (String?)->()) {
        // 判断用户名
        guard let tempUserName = userName, tempUserName != "" else {
            completion("")
            return
        }
        
        // 请求数据
        let queue = DispatchQueue.init(label: "getCommonUseLanguage")
        queue.async {
            let urlStrLanguage: String = api_getUserRepos + tempUserName + "/repos?client_id=bd2eebc709ab4c567100&client_secret=006967600a3b28cff268d8a8251c3b3a948f89b0"
            
            AFNetWorking.manager.getRequest(urlStrLanguage, success: { (result) in
                guard let tempResult = result else {
                    completion("")
                    return
                }
                let resultArray: [Any]? = tempResult as? [Any]
                guard let tempResultArray = resultArray else {
                    completion("")
                    return
                }
                
//            计算用户使用最多的语言
                let commonLanguage = self.mostLanguage(array: tempResultArray)
                completion(commonLanguage)
                
            }) { (error) in
                completion("")
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
    
}
